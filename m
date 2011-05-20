From: Miguel Garrido <miguel@mjgar.com>
Subject: Re: No space left, with 80 GB space free
Date: Fri, 20 May 2011 19:05:54 -0400
Message-ID: <BANLkTimA_dJDNUqPUssV5ZbLTr=T7k+doA@mail.gmail.com>
References: <4DD16817.9020302@wpkg.org>
	<4DD6985E.8040100@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD6985E.8040100@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2011 at 12:35 PM, Tomasz Chmielewski <mangoo@wpkg.org> =
wrote:
>
> Nobody has a clue what makes btrfs run out of space when used with Po=
stgreSQL, even when there is plenty of free space left?
>
>
> # df -h
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/sdb4 =A0 =A0 =A0 =A0 =A0 =A0 336G =A0257G =A0 78G =A077% /mnt/bt=
rfs
>
>
> coredb=3D# DELETE FROM core_trevent where "date" < E'2011-05-07 00:00=
';
> ERROR: =A0could not write block 1014999 of relation base/16384/16521:=
 No space left on device
> CONTEXT: =A0writing block 1014999 of relation base/16384/16521
>

Hi Tomasz,

What does btrfs fi df /mountpoint show?

Please see this link:
https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_=
out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
As well as this one:
https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_there_so_many_ways_=
to_check_the_amount_of_free_space.3F


--=20
MG
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
