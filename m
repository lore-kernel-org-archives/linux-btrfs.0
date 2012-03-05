From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Mon, 5 Mar 2012 14:07:00 +0700
Message-ID: <CAG1y0sdy0p2D4AHBcHgiYxPYknbW8O3xgCuvwKy==sWnW5BJAg@mail.gmail.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
	<1330484376-16178-2-git-send-email-anand.jain@oracle.com>
	<CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
	<4F54625E.6040003@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org,
	hugo@carfax.org.uk, chris.mason@oracle.com
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F54625E.6040003@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 5, 2012 at 1:51 PM, Anand Jain <Anand.Jain@oracle.com> wrot=
e:
>
>> (notably the direct modification of
>> crontab files, which is considered to be an internal detail if I
>> understand correctly, and I'm fairly certain is broken as written),
>
>
> =A0I did came across that point of view however, using crontab cli in=
 the
> =A0program wasn't convincing either, (library call would have been be=
tter).
> =A0any other better ways to manage cron entries ?
>

/etc/cron.{d,daily,hourly} ?

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
