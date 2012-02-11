From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: Freeing space over reboot question
Date: Sat, 11 Feb 2012 17:42:25 +0100
Message-ID: <20120211164225.263630@gmx.net>
References: <20120209174232.318280@gmx.net>	<20120210002055.6819f76c@natsu>
	<20120211134715.200530@gmx.net> <20120211195632.59931608@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120211195632.59931608@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 11 Feb 2012 19:56:32 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> > Have You tried it Yourself? I think the problem was the remount
> > before the space has been completely freed in background. It
> > left a valid and working fs, with still work to do.
> 
> Yes, after some snapshot deletions the umount takes a really long time.

Ok, then the question is, why did this not happen here?
 
> > In my opinion the kernel should either stall the umount till the
> > space is given free
> 
> In my experience it seemed to do just that.

Hm, I did the umount under kernel 3.1 and after the reboot
I used kernel 3.2. Is that the reason?

Regards
    Norbert
