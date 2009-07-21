From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: Random write regression
Date: Tue, 21 Jul 2009 15:04:04 +0800
Message-ID: <3d0408630907210004g34a49196xb235aa2f6a1f0f1b@mail.gmail.com>
References: <4A646D0E.1060006@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A646D0E.1060006@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/7/20 Steven Pratt <slpratt@austin.ibm.com>:
> Finally got around to going through latest data. =A0Seems like we los=
t all the
> random write performance gains. =A0Creates are better, but total regr=
ession on
> the random workload. =A0Sequential reads seem to have dropped as well=
=2E
>
> Results are uploading now.
> =A0http://btrfs.boxacle.net/repository/raid/history/History.html
>
> These are for RAID only as single disk system still having issues com=
pleting
> btrfs runs. =A0Also, missing oprofile duw to oprofile causing an NMI =
and
> killing the system.
>
> Chris, this was built on 7/6, but I see no new changes sine 7/2/.
> Steve
>
>

The output of ffsb in the latest 128 threads random odirect write bench=
mark was
=2E...
checking existing fs: /mnt/ffsb1
fs setup took 6 secs
Syncing()...2 sec
=2E...

The corresponding output on 30 June was
=2E...
creating new fileset /mnt/ffsb1
fs setup took 847 secs
Syncing()...1 sec
=2E...

It seems the filesystem used in the latest benchmark wasn't freshly cre=
ated.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
