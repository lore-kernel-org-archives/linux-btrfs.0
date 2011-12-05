From: Christian Brunner <chb@muc.de>
Subject: Re: [PATCH] Btrfs: protect orphan block rsv with spin_lock
Date: Mon, 5 Dec 2011 12:50:39 +0100
Message-ID: <CAO47_-9=1Cai3Ux2CR-xc5DarRyQkEMWdFXk7=DKyU6OrDamOA@mail.gmail.com>
References: <1322858676-4278-1-git-send-email-josef@redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, sage@newdream.net
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322858676-4278-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/2 Josef Bacik <josef@redhat.com>:
> We've been seeing warnings coming out of the orphan commit stuff fore=
ver from
> ceph. =A0Turns out it's because we're racing with checking if the orp=
han block
> reserve is set, because we clear it outside of the spin_lock. =A0So l=
eave the
> normal fastpath checks where they are, but take the spin_lock and _re=
check_ to
> make sure we haven't had an orphan block rsv added in the meantime. =A0=
Then clear
> the root's orphan block rsv and release the lock. =A0With this patch =
a user said
> the warnings went away and they usually showed up pretty soon after h=
e started
> ceph. =A0Thanks,

*sigh* - As soon as I turned my back to the serve console it also
happened again on one of our nodes. That was 25 hours after I started
the system. Usually I see these warnings a few minutes after the
start, but the have been cases in the past where it took longer. So
I'm not sure if the improvement is due to the patch.

Josef: I was still running the patch you sent me, but there was no
message from the printk's you added.

Thanks,
Christian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
