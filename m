From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 5 Jan 2011 12:34:03 -0800
Message-ID: <AANLkTi=ZzZX_U1+fVqqR+FUSfsmuvO8yLvUomgU+rr8d@mail.gmail.com>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
	<4D24AD92.4070107@bobich.net>
	<20110105194645.GC2562@localhost.localdomain>
	<1294257493.2953.33.camel@havelock.lan>
	<20110105201518.GD2562@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110105201518.GD2562@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 5, 2011 at 12:15 PM, Josef Bacik <josef@redhat.com> wrote:
> Yeah for things where you are talking about sending it over the netwo=
rk or
> something like that every little bit helps. =C2=A0I think deduplicati=
on is far more
> interesting and usefull at an application level than at a filesystem =
level. =C2=A0For
> example with a mail server, there is a good chance that the files wil=
l be
> smaller than a blocksize and not be able to be deduped, but if the ap=
plication
> that was storing them recognized that it had the same messages and ju=
st linked
> everything in its own stuff then that would be cool. =C2=A0Thanks,

Cyrus IMAP and Zimbra (probably a lot of others) already do that,
hard-linking identical message bodies.  The e-mail server use-case is
for dedupe is pretty much covered already.


--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
