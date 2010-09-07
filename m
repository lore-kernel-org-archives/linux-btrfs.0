From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: Re: mkfs or wait?
Date: Tue, 7 Sep 2010 13:45:35 +0000 (UTC)
Message-ID: <i65flv$6tn$1@dough.gmane.org>
References: <i64k40$ur1$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Lubos Kolouch, Tue, 07 Sep 2010 05:55:12 +0000:

> Hello,
> 
> I have on one computer damaged btrfs filesystem... it was a strange
> crash, it showed about 30% free space, however then the volume crashed
> with 'no space left' messages and after reboot it is unusable.
> 
> I can mount it, I can df it but when I try for example ls, ls gets stuck
> (does not display anything) and I get - in the syslog
> verify_parent_transid: 22336 callbacks suppressed parent transid verify
> failed on 1066975232 wanted 125077 found 125075 parent transid verify
> failed on 974635008 wanted 125077 found 125075 parent transid verify
> failed on 1066975232 wanted 125077 found 125075 parent transid verify
> failed on 974635008 wanted 125077 found 125075 parent transid verify
> failed on 1066975232 wanted 125077 found 125075 parent transid verify
> failed on 974635008 wanted 125077 found 125075 parent transid verify
> failed on 1066975232 wanted 125077 found 125075 parent transid verify
> failed on 974635008 wanted 125077 found 125075 parent transid verify
> failed on 1066975232 wanted 125077 found 125075 parent transid verify
> failed on 974635008 wanted 125077 found 125075
> 
> - top shows
> ls
> [btrfs-endio-met]
> [btrfs-cache-293]
> 
> - btrfs segfaults
> 
> It is like this over a day. Should I just mkfs it or is there anything
> sensible I could try?
> 
> kernel 2.6.35-gentoo-r5, latest git btrfs-progs
> 
> Thank you for your advice.
> 
> Lubos

Funny thing - under 2.6.34-r1 it works, ie. I can mount it and view files
(even though the errors in log are still there).

Regression in 2.6.35?

Lubos

