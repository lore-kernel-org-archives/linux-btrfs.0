From: Olivier Bonvalet <btrfs.list@daevel.fr>
Subject: Re: btrfs-convert processing time
Date: Fri, 30 Mar 2012 21:23:52 +0200
Message-ID: <4F760848.4020600@daevel.fr>
References: <4F4241D1.4080506@daevel.fr> <20458953.qbO19NXijp@k85hala03> <4F424D8D.4030802@daevel.fr> <1920178.zXOEpupmQW@k85hala03> <CAG1y0sevgB0=Y-Sxe_N4zGeZvYp+Pmpjv0q8JeRg22qtkZ0tJw@mail.gmail.com> <4F4258D5.4070101@daevel.fr> <CAG1y0sdUeXwMXRfeuqOosRtpj_TpB_8cxw0xpGXw+LaRDSAD9A@mail.gmail.com> <4F451E1A.4000802@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F451E1A.4000802@daevel.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Le 22/02/2012 17:55, Olivier Bonvalet a =E9crit :
> So, the btrfs-convert for the smaller drive is done... after near 5 d=
ays. Which stats can I give you ?
>
> It's a 340GB LVM block device, and "btrfs filesystem df /backup/" say=
 that :
>
> Data: total=3D225.97GB, used=3D181.94GB
> System: total=3D32.00MB, used=3D24.00KB
> Metadata: total=3D111.00GB, used=3D91.56GB
>
>
> If I mount the ext2_saved/image copy, I can see 257GB of data (78% of=
 the block device used), with 17M of inodes.
>
>
> The other btrfs-convert stay running.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

Well, the second one is still running :

root! backup:~# uptime
  21:17:43 up 41 days, 19:59,  1 user,  load average: 2.06, 1.90, 1.88


root! backup:~# ps auxw | grep btrfs
root      1978 25.6 74.3 1269072 1141212 ?     D    Feb18 15421:50 btrf=
s-convert /dev/vg-backup/backup


root! backup:~# iostat -k
Linux 2.6.42.3-dae-xen (backup) 	30/03/2012 	_x86_64_	(2 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           10,54    0,06    2,36   54,21    0,09   32,74

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
xvda            724,70       175,50      3181,13  634342597 11498370400
xvdy              0,00         0,00         0,00       1381          0
xvdz              0,00         0,00         0,00       4065          0
dm-0              0,49         3,22         1,78   11627497    6435028
dm-1            837,57       171,69      3178,57  620593936 11489105416
dm-2              0,34         0,59         0,78    2120800    2830584

11498370400 kB written, so, 11TB written to convert a 518GB partition ?


but more important : is it safe to abort the process ?

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
