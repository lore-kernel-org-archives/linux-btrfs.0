Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3AGSD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 13:03:57 -0500
Message-ID: <50EB0DE0.9040500@redhat.com>
Date: Mon, 07 Jan 2013 12:03:12 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Kiran Patil <kirantpatil@gmail.com>, linux-btrfs@vger.kernel.org,
        bo.li.liu@oracle.com
Subject: Re: Open for contribution towards xfstests for btrfs
References: <CANT588vv8xYNWGBSZUDu0vui2ZH4QqL7tvQX8zOGof7nucC6_Q@mail.gmail.com> <CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com> <20130107153132.GH20089@twin.jikos.cz>
In-Reply-To: <20130107153132.GH20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/7/13 9:31 AM, David Sterba wrote:
> On Mon, Jan 07, 2013 at 03:48:43PM +0530, Kiran Patil wrote:
>> We have a team of 5 students who would like to contribute to btrfs
>> filesystem testing using xfstests.
> 
> By any chance, are these the same people behind
> http://sourceforge.net/projects/btrfstest/ ?

If so, you might want to consider that

http://www.tuxera.com/community/posix-test-suite/

probably already covers some of the tests that "btrfstest" is
(re)writing.  i.e.:

+/* Creating Link on non-existing prefix path should return ENOTDIR

and

+/* Creating link on ENAMETOOLONG if either file name exceeds maximum characters

are almost certainly covered in the above posix test suite.

FWIW, that testsuite has a few failures on btrfs (not all unique to btrfs, IIRC):

Test Summary Report
-------------------
/root/pjd-fstest/pjd-fstest-20090130-RC/tests/chown/00.t   (Wstat: 0 Tests: 171 Failed: 6)
  Failed tests:  84, 88, 141, 145, 149, 153
/root/pjd-fstest/pjd-fstest-20090130-RC/tests/truncate/00.t (Wstat: 0 Tests: 21 Failed: 1)
  Failed test:  15
/root/pjd-fstest/pjd-fstest-20090130-RC/tests/xacl/00.t    (Wstat: 0 Tests: 45 Failed: 1)
  Failed test:  45

-Eric



