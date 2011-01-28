From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Fri, 28 Jan 2011 03:54:35 +0100
Message-ID: <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <1296166345.11397.16.camel@mainframe> <1865303E0DED764181A9D882DEF65FB685DF7629F2@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Maria =?utf-8?q?Wikstr=C3=B6m?= <maria@ponstudios.se>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB685DF7629F2@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 28 January 2011 02:26:43 Zhong, Xin wrote:
> Please try the fix in below link:
> http://www.spinics.net/lists/linux-btrfs/msg08051.html
> 
> Thanks!

This doesn't fix it for me. At least there is a difference. Whereas the svn 
process started consuming 100% CPU without any further interaction before, the 
system just hang now. The svn process starts eating the CPU when I cancel the 
emerge via ctrl-c. Additional I see a flush-btrfs task now consuming CPU time.

regards,
  Johannes
