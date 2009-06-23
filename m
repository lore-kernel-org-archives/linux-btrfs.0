From: Miguel F Mascarenhas Sousa Filipe <miguel.filipe@gmail.com>
Subject: Re: Phoronix article slaming BTRFS
Date: Tue, 23 Jun 2009 11:13:12 +0100
Message-ID: <f058a9c30906230313v10d94a5eg8cf123cef30fb5b8@mail.gmail.com>
References: <loom.20090623T024010-331@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Mike Ramsey <MikeJRamsey@comcast.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20090623T024010-331@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2009 at 3:51 AM, Mike Ramsey<MikeJRamsey@comcast.net> w=
rote:
> I ran across this article "Testing Out The SSD Mode In Btrfs".
> http://www.phoronix.com/scan.php?page=3Darticle&item=3Dbtrfs_ssd_mode=
&num=3D1
>
> At first I was disappointed. =C2=A0It gave a very disappointing set o=
f benchmarks.
> However, a close reading revealed this:
>
> "With the OCZ Vertex SATA 2.0 SSD, which we used for this testing tod=
ay, had its
> write caching always enabled. When attempting to disable the write ca=
che through
> hdparm it would remain enabled regardless and when using sdparm it wo=
uld report
> change_mode_page: failed setting page: Caching (SBC)."
>
> This invalidates the benchmark! Disabling the write cache would yield=
 a 2X
> improvement.
>
> Digging deeper, I found this:
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg07949.html
>
> " Michael,
> =C2=A0My information may be out of date, but last time I
> =C2=A0looked libata didn't support MODE SELECT which is
> =C2=A0the SCSI command to change mode page settings.
> =C2=A0[I have sent patches several times to add support
> =C2=A0for this in libata but ...]
>
> Ahhha!!!
>
> That looks exactly the case.
>
> I tested the two drives (AS and NS ones) on different
> machines, and currently, NS (where things doesn't work)
> is connected to AHCI controller, while the AS one is
> behind mptsas. =C2=A0So it just looks like mptsas is doing
> the right thing in the first place, while ahci (or
> libata, whatever) is failing."
>
> So the article managed to unjustly smear both OCZ Vertex and BTRFS in=
 one shot.

allways take phoronix tests with a very big grain of salt. :-p

usually they are made/prepared "with their eyes closed".. completely
in the dark and they don't diagnose or try to understand the results.
nevertheless, they do test stuff out...


>
> --Mike Ramsey
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Miguel Sousa Filipe
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
