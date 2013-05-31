Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:45795 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3EaUno (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 16:43:44 -0400
Received: by mail-vb0-f45.google.com with SMTP id 12so1373878vbf.18
        for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 13:43:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYTDjRmU5gJGyD=Wp6JhOqaT64ytJZNujCTGX9RheGcHjQ@mail.gmail.com>
References: <CAFvQSYShdQL_pZB12=Xt7dg+yLt0NNCW+WTyOXgic3SbFDy69w@mail.gmail.com>
	<CAFvQSYS1odBm3+ttcuQCZuxmWuVfUkCatQw1bAG_B_uTJVmCmw@mail.gmail.com>
	<20130530185539.GD9829@localhost.localdomain>
	<CAFvQSYTDjRmU5gJGyD=Wp6JhOqaT64ytJZNujCTGX9RheGcHjQ@mail.gmail.com>
Date: Fri, 31 May 2013 22:43:43 +0200
Message-ID: <CAFvQSYSWgPwBDXS_H6w9fUxZ1Bzz4t3u=ynY=oCtgOBGb3zyoA@mail.gmail.com>
Subject: Re: Btrfsck errors (fs tree 565 refs 125 not found) - how serious
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

>> You are running on an unmounted fs right?  Also please make sure you are running
>> the git version
>
> Yes, the fs was properly unmounted.
>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> I still get those errors, I'll try to file a bug-report with the
> tools/data required to reproduce this issue...

Filed at: https://bugzilla.kernel.org/show_bug.cgi?id=59051

Regards
