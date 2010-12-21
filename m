From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Scary OOPS when playing with --bind, --move, and friends
Date: Tue, 21 Dec 2010 11:19:50 +0700
Message-ID: <AANLkTi=pXkg1YV9z9GP7Q_vbNj5ZVOcfTfqYJW=QbSvC@mail.gmail.com>
References: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
	<AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 21, 2010 at 11:16 AM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Tue, Dec 21, 2010 at 10:51 AM, C Anthony Risinger <anthony@extof.me> wrote:
>> i'm on 2.6.36.2
>
> Try 2.6.35 or later. I tested something similar under ubuntu maverick
> (2.6.35-24-generic) and it works just fine.

Sorry, hit "send" to soon. I though you wrote "2.6.32" :P

Still curious about your test scenario though. Can you double check
it? A write on the snapshot should not appear on the parent
filesystem.

-- 
Fajar
