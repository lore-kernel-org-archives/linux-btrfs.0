Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:40564 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdKUNQK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 08:16:10 -0500
Received: by mail-lf0-f43.google.com with SMTP id d10so3022975lfj.7
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 05:16:09 -0800 (PST)
Message-ID: <1511270165.1680.33.camel@gmail.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
From: ST <smntov@gmail.com>
To: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Date: Tue, 21 Nov 2017 15:16:05 +0200
In-Reply-To: <CAKuJGC8g1Oa-1w=v8dUxuj6qF8MXOcJ=K7uHQaJumnW4YTRNrQ@mail.gmail.com>
References: <1511266131.1680.27.camel@gmail.com>
         <CAKuJGC8g1Oa-1w=v8dUxuj6qF8MXOcJ=K7uHQaJumnW4YTRNrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am on Debian 9 (stable), so kernel version is:
uname -r
4.9.0-4-amd64

btrfs-tools (4.7.3-1)

It might be related to the bug you have referred to (since once I hit
the quota limit I tried then to add some small files to check whether
quota works). However my main problem is - why I can't REMOVE files?! I
get error while I try to free space!

In my real use case I'll have quota limit of minimum 100G, is it
possible that the issue is caused by the small 1M (test) limit and will
not appear in real use case?

Thank you!


On Tue, 2017-11-21 at 17:55 +0530, Lakshmipathi.G wrote:
> Seems like issue is similar to this bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=197681
> Whats your kernel/brtfs-prog version? Can you upgrade them to latest
> if they are quite old?
> ----
> Cheers,
> Lakshmipathi.G
> http://www.giis.co.in http://www.webminal.org
> 
> 
> On Tue, Nov 21, 2017 at 5:38 PM, ST <smntov@gmail.com> wrote:
> > Hello,
> >
> > I'm trying to use quotas for a simple chrooted sftp setup, limiting
> > space for each user's subvolume (now for testing to 1M).
> >
> > I tried to hit the limit by uploading files and once it comes to the
> > limit I face following problem: if I try to free space by removing a
> > file via Linux sftp client (or Filezilla) - I get error:
> > "Couldn't delete file: Failure"
> >
> > Sometimes, but not always, if I repeat it for 3-5 times it does removes
> > the file at the end.
> > If I login as root and try to remove the file via SSH I get the error:
> > "rm: cannot remove 'example.txt': Disk quota exceeded"
> >
> > What is the problem? And how can I solve it?
> >
> > Thank you in advance!
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

