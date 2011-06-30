From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs lock-up on copying files
Date: Thu, 30 Jun 2011 10:52:57 -0400
Message-ID: <4E0C8DC9.6080402@redhat.com>
References: <20110630123738.6042e563@natsu>	<4E0C8A3F.2060202@redhat.com> <20110630204347.0d70506e@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630204347.0d70506e@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2011 10:43 AM, Roman Mamedov wrote:
> On Thu, 30 Jun 2011 10:37:51 -0400
> Josef Bacik <josef@redhat.com> wrote:
> 
>> Can you do sysrq+w when this happens?  The caching kthread should still
>> be able to make progress, which is what we seem to be waiting on.  Does
>> it eventually unhang and continue on?  Thanks,
> 
> Hello,
> 
> Unfortunately I already rebooted that server so can't check SysRq+W.
> Before the reboot I waited for about 40 minutes, and the block device seemed to be 100% idle during all this time.
> I got an advice on IRC to wait for a couple of hours if this happens again, which I am going to try if it does.
> 

Oh well crud I see what happened, the caching_kthread didn't even get
started, kthreadd got locked up waiting on the page lock for migration.
 I will try and figure out what to do for this.  Thanks for reporting it,

Josef
