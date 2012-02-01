From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: How to get trace during crash?
Date: Wed, 01 Feb 2012 10:07:50 +0800
Message-ID: <4F289E76.8070103@gmail.com>
References: <CAAE6i0ianz6CvFNLRCEPOyoQ4UPwZDg3WYqk+pj0AL-mjfac5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0ianz6CvFNLRCEPOyoQ4UPwZDg3WYqk+pj0AL-mjfac5Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/01/2012 02:04 AM, Chester wrote:
> In the event of a filesystem crash, how do I extract the debugging
> info for the mailing list? My attempts to SSH into the machine are
> unresponsive.
>

In this case, probably you need netconsole, see 
Documentation/networking/netconsole.txt for details.
