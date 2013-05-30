Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:54462 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3E3Tgp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 15:36:45 -0400
Received: by mail-ve0-f174.google.com with SMTP id oz10so516305veb.33
        for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 12:36:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130530185539.GD9829@localhost.localdomain>
References: <CAFvQSYShdQL_pZB12=Xt7dg+yLt0NNCW+WTyOXgic3SbFDy69w@mail.gmail.com>
	<CAFvQSYS1odBm3+ttcuQCZuxmWuVfUkCatQw1bAG_B_uTJVmCmw@mail.gmail.com>
	<20130530185539.GD9829@localhost.localdomain>
Date: Thu, 30 May 2013 21:36:43 +0200
Message-ID: <CAFvQSYTDjRmU5gJGyD=Wp6JhOqaT64ytJZNujCTGX9RheGcHjQ@mail.gmail.com>
Subject: Re: Btrfsck errors (fs tree 565 refs 125 not found) - how serious
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

> You are running on an unmounted fs right?  Also please make sure you are running
> the git version

Yes, the fs was properly unmounted.

> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

I still get those errors, I'll try to file a bug-report with the
tools/data required to reproduce this issue...

Thanks, Clemens
