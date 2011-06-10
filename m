From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 00/11 v2] Btrfs: improve write ahead log with sub transaction
Date: Fri, 10 Jun 2011 08:52:42 +0800
Message-ID: <4DF16ADA.40903@cn.fujitsu.com>
References: <1306397966-7834-1-git-send-email-liubo2009@cn.fujitsu.com> <20110610004053.GR12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110610004053.GR12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2011 08:40 AM, David Sterba wrote:
> Hi,
> 
> is it possible to refresh this patchset and resend? I'd like to enroll
> it and give it some review and testing. So far I have seen notions and
> use of trans_mutex, which has been removed.
> 

Sure, thanks for the passion.

Yea, I've noticed the trans_mutex thing, but I'm afraid I have to do this
till next week, cause these is a "btrfs fi bal" bug still on going on my schedule.

thanks,
liubo 

> 
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

