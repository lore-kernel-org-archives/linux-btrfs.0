From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: protect orphan block rsv with spin_lock
Date: Mon, 5 Dec 2011 09:30:09 -0500
Message-ID: <20111205143008.GA3046@localhost.localdomain>
References: <1322858676-4278-1-git-send-email-josef@redhat.com>
 <CAO47_-9=1Cai3Ux2CR-xc5DarRyQkEMWdFXk7=DKyU6OrDamOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	sage@newdream.net
To: Christian Brunner <chb@muc.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9=1Cai3Ux2CR-xc5DarRyQkEMWdFXk7=DKyU6OrDamOA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2011 at 12:50:39PM +0100, Christian Brunner wrote:
> 2011/12/2 Josef Bacik <josef@redhat.com>:
> > We've been seeing warnings coming out of the orphan commit stuff fo=
rever from
> > ceph. =A0Turns out it's because we're racing with checking if the o=
rphan block
> > reserve is set, because we clear it outside of the spin_lock. =A0So=
 leave the
> > normal fastpath checks where they are, but take the spin_lock and _=
recheck_ to
> > make sure we haven't had an orphan block rsv added in the meantime.=
 =A0Then clear
> > the root's orphan block rsv and release the lock. =A0With this patc=
h a user said
> > the warnings went away and they usually showed up pretty soon after=
 he started
> > ceph. =A0Thanks,
>=20
> *sigh* - As soon as I turned my back to the serve console it also
> happened again on one of our nodes. That was 25 hours after I started
> the system. Usually I see these warnings a few minutes after the
> start, but the have been cases in the past where it took longer. So
> I'm not sure if the improvement is due to the patch.
>=20
> Josef: I was still running the patch you sent me, but there was no
> message from the printk's you added.
>=20

:( ok I'll try again.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
