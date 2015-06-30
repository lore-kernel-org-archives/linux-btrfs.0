Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbbF3Mky (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 08:40:54 -0400
Date: Tue, 30 Jun 2015 14:40:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Amr El-Sharnoby <amr.elsharnoby@horizontechs.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs 4.1 failed to compile on CentOS 6.x
Message-ID: <20150630124052.GF726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAGMys1p9=p-22mfSMCtMXgrmA=1mOs0mzRBTDmt_67q8D4OJEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGMys1p9=p-22mfSMCtMXgrmA=1mOs0mzRBTDmt_67q8D4OJEw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 11:59:50AM +0300, Amr El-Sharnoby wrote:
> Compilation of btrfs-progs 4.1 failed on CentOS 6.6 with latest
> updated packages with the folllowing error,
> In file included from cmds-inspect.c:28:
> send-utils.h:97: error: wrong number of arguments specified for
> ‘deprecated’ attribute
> send-utils.h:99: error: wrong number of arguments specified for
> ‘deprecated’ attribute
> make: *** [cmds-inspect.o] Error 1
> 
> Previous version compile successfully.

What's the version of gcc ? It works on my test setup with 4.5 and
afaics this is the first version where the optional argument appeared.
