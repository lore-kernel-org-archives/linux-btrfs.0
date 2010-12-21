From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Scary OOPS when playing with --bind, --move, and friends
Date: Tue, 21 Dec 2010 11:16:12 +0700
Message-ID: <AANLkTimRGDPLW1Un0BubAsM7kF=vx9eYQOxK3EvHWx-V@mail.gmail.com>
References: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikwFUOUE4i3Whyh2_jfH+fPdK3GYL09vCqmuCod@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 21, 2010 at 10:51 AM, C Anthony Risinger <anthony@extof.me> wrote:
> in short, everything works fine until you --bind across a subvol via
> the "special" folders created when one takes a snapshot,

> # mount --bind root/<subvol of my current root>/home/anthony bind
> # touch bind/TEST
>
> <you can now see TEST at ~/TEST and bind/TEST>

bind/ is a mounted snapshot, right? if yes, then when you "touch
bind/TEST", it should also appear in root/<subvol of my current
root>/home/anthony/TEST, and NOT in root/home/anthony/TEST or
/home/anthony/TEST

> i'm on 2.6.36.2

Try 2.6.35 or later. I tested something similar under ubuntu maverick
(2.6.35-24-generic) and it works just fine.

-- 
Fajar
