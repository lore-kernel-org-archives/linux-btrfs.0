Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:40376 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3CWJs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 05:48:27 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Chris Mason <clmason@fusionio.com>
Cc: Samuel Just <sam.just@inktank.com>,
        "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ceph-devel\@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: corruption of active mmapped files in btrfs snapshots
References: <orhak8fm0u.fsf@livre.home> <or1ubaesrx.fsf@livre.home>
	<ord2utb4xx.fsf@livre.home>
	<20130321180614.30044.29961@localhost.localdomain>
	<20130321230621.30044.80640@localhost.localdomain>
	<orzjxw9f75.fsf@livre.home>
	<20130322120754.27874.14389@localhost.localdomain>
	<orobeba58l.fsf@livre.home>
	<20130322142659.27874.81283@localhost.localdomain>
	<CA+4uBUbyF-3yiBQ00xP4NHEX96CXa9HZo5-ZYdZ3Fjrfnm=Ssw@mail.gmail.com>
	<20130322171214.27874.48118@localhost.localdomain>
Date: Sat, 23 Mar 2013 06:47:26 -0300
In-Reply-To: <20130322171214.27874.48118@localhost.localdomain> (Chris Mason's
	message of "Fri, 22 Mar 2013 13:12:14 -0400")
Message-ID: <or620ia1n5.fsf@livre.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

On Mar 22, 2013, Chris Mason <clmason@fusionio.com> wrote:

> Quoting Samuel Just (2013-03-22 13:06:41)
>> Incomplete writes for leveldb should just result in lost updates, not
>> corruption.

> In this case, I think Alexandre is scanning for zeros in the file.

Yup, the symptom is zeros at the end of a page, with nonzeros on the
subsequent page, which indicates that the writes to the previous page
were dropped.

What I actually do is to iterate over the entire database, which will
error out when the block header is found to be corrupted.  I use this
program I wrote (also hereby provided under GNU GPLv3+) to check the
database for corruption.


--=-=-=
Content-Type: text/x-c++src
Content-Disposition: inline; filename=dbck.cc

#include <assert.h>
#include <iostream>
#include "leveldb/db.h"

int main(int argc, char *argv[]) {
  bool paranoid = false;
  bool dump = false;
  bool repair = false;
  bool quiet = false;
  int i = 0;
  int errors = 0;

  if (argc == 1) {
  usage:
    std::cout << "usage: [flags] dbname [flags] ..." << std::endl
	      << "-d --dump     dump database contents" << std::endl
	      << "-r --repair   repair database" << std::endl
	      << "-p --paranoid enable paranoid mode" << std::endl
	      << "-l --lax      disable paranoid mode (default)" << std::endl
	      << "-q --quiet    enable quiet mode" << std::endl
	      << "-v --verbose  disable quiet mode (default)" << std::endl
	      << "-h --help     show this message and exit" << std::endl
	      << "dbname        check, dump and repair" << std::endl
	      << std::endl
	      << "exit status is the number of errors" << std::endl;
    return errors;
  }

  for (i++; i < argc; i++) {
    if (argv[i][0] == '-') {
      if (strcmp (argv[i], "--dump") == 0
	  || strcmp (argv[i], "-d") == 0)
	dump = true;
      else if (strcmp (argv[i], "--repair") == 0
	       || strcmp (argv[i], "-r") == 0)
	repair = true;
      else if (strcmp (argv[i], "--paranoid") == 0
	       || strcmp (argv[i], "-p") == 0)
	paranoid = true;
      else if (strcmp (argv[i], "--lax") == 0
	       || strcmp (argv[i], "-l") == 0)
	paranoid = false;
      else if (strcmp (argv[i], "--quiet") == 0
	       || strcmp (argv[i], "-q") == 0)
	quiet = true;
      else if (strcmp (argv[i], "--verbose") == 0
	       || strcmp (argv[i], "-v") == 0)
	quiet = false;
      else if (strcmp (argv[i], "--help") == 0
	       || strcmp (argv[i], "-h") == 0)
	goto usage;
      else {
	std::cerr << "unrecognized option: " << argv[i] << std::endl;
	goto usage;
      }
    } else {
      if (!quiet)
	std::cout << argv[i] << std::endl;

      leveldb::DB* db;
      leveldb::Options options;
      options.paranoid_checks = paranoid;
      leveldb::Status status = leveldb::DB::Open(options, argv[i], &db);
      bool bad = false;

      if (!status.ok()) {
	std::cerr << status.ToString() << std::endl;
	bad = true;
      } else {
	leveldb::ReadOptions rdopt;
	rdopt.verify_checksums = paranoid;
	rdopt.fill_cache = false;
	leveldb::Iterator* it = db->NewIterator(rdopt);
	int count = 0;
	try {
	  for (it->SeekToFirst(); it->Valid(); it->Next()) {
	    count++;
	    if (dump)
	      std::cout << it->key().ToString() << ": "
			<< it->value().ToString() << std::endl;
	    else if (!quiet && count % 1000 == 0)
	      std::cout << count << " entries\r" << std::flush;
	  }
	  if (!it->status().ok()) {
	    std::cerr << it->status().ToString() << std::endl;
	    bad = true;
	  }
	} catch (...) {
	  std::cerr << "caught an exception" << std::endl;
	}
	delete it;
	if (!quiet)
	  std::cout << count << " entries" << std::endl;
      }

      delete db;

      if (bad) {
	errors++;
	if (repair) {
	  if (!quiet)
	    std::cout << "repairing..." << std::endl;
	  status = RepairDB(argv[i], options);
	  if (!status.ok()) {
	    std::cerr << status.ToString() << std::endl;
	    errors++;
	  }
	} else if (!quiet)
	  std::cout << "use --repair to repair" << std::endl;
      }
    }
  }

  return errors;
}

--=-=-=



-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer

--=-=-=--
