From: Maria =?ISO-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Fri, 28 Jan 2011 17:47:21 +0100
Message-ID: <1296233241.11428.23.camel@mainframe>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
	 <1296166345.11397.16.camel@mainframe>
	 <1865303E0DED764181A9D882DEF65FB685DF7629F2@shsmsx502.ccr.corp.intel.com>
	 <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org, johannes.hirte@fem.tu-ilmenau.de
To: xin.zhong@intel.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

fre 2011-01-28 klockan 03:54 +0100 skrev Johannes Hirte: 
> On Friday 28 January 2011 02:26:43 Zhong, Xin wrote:
> > Please try the fix in below link:
> > http://www.spinics.net/lists/linux-btrfs/msg08051.html
> > 
> > Thanks!
> 
> This doesn't fix it for me. At least there is a difference. Whereas the svn 
> process started consuming 100% CPU without any further interaction before, the 
> system just hang now. The svn process starts eating the CPU when I cancel the 
> emerge via ctrl-c. Additional I see a flush-btrfs task now consuming CPU time.
> 
> regards,
>   Johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

The patch makes the process exit cleanly but complains that there is no
space left. It should be a few GB but it is only a few MB!? I delete 5GB
and controls that the space is usable. Try again but this time it almost
hangs the system, I can blink the leds and move the mouse but noting
more. 
I boot 2.6.36.1 and use a snapshot as root, "emerge libgcrypt" compiles
and installs fine. Boots back into 2.6.37 and try again and the system
hangs again.

// Maria


