Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35069 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLHSSA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 13:18:00 -0500
Received: by mail-qc0-f181.google.com with SMTP id m20so3845433qcx.26
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 10:17:59 -0800 (PST)
Message-ID: <5485EB23.8040103@ubuntu.com>
Date: Mon, 08 Dec 2014 13:17:07 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <5485C432.3030307@ubuntu.com> <5485E1A0.4030602@gmail.com>
In-Reply-To: <5485E1A0.4030602@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/8/2014 12:36 PM, Goffredo Baroncelli wrote:
> I like this approach, but as I wrote before, it seems that 
> initramfs executes a "btrfs dev scan".... (see my previoue email 
> 'Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their
> snapshots' date 2014/12/03 9:34):
> 
> $ grep -r "btrfs dev.*scan" /usr/share/initramfs-tools/ 
> /usr/share/initramfs-tools/scripts/local-premount/btrfs:
> /sbin/btrfs device scan 2> /dev/null
> 
> (this is from a debian). However it has to be pointed out that 
> fedora doesn't seems to do the same...

Need to fix that initramfs script then.  On the other hand, if one
*does* run a scan with no arguments, then it probably is a good idea
to ignore snapshots.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUhesjAAoJENRVrw2cjl5RPRAIALK5ERJqRJLSsa6kBSIP8bWe
WP531ew49I0Tkc0o3YOCqq07tb4kZ5rsLsPaLE+s3adCe5/wYzQOox4x6ucak1gK
0igazFx9TYM65YRtFzIUAnj/CPN4WwIInwoAac4w2qwCKB56WUbSU60lEsOmFfRr
6m9EUYkBtMRiWfW2jjuj8iLnBW6glexAqTpW1eKWPfF0AGoUXc8AQboNwceFnHi3
vcjmQM6mhL5zH+FJ0Z/meTk/PwVdjEVJQIEcbMpvggAJeqxsm90GHVIsn8C7B80i
GcX8GHe+Gw3WJMsaW49slKa+MOjWt2SumN/lrKFYPVwQUguhvg0hC1UG5m3cJFo=
=64dH
-----END PGP SIGNATURE-----
