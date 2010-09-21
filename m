From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Performance degradation
Date: Tue, 21 Sep 2010 00:27:03 -0400
Message-ID: <AANLkTi=569wzOheD_eeai6O7uaWBxMhRv5_YuUE1dJZb@mail.gmail.com>
References: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
	<D1A263E5-C03A-4D6B-BC4D-6085F10714E1@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <D1A263E5-C03A-4D6B-BC4D-6085F10714E1@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 20, 2010 at 9:19 PM, K. Richard Pixley <rich@noir.com> wrot=
e:
> Do you have any kernel processes running constantly? =A0Any taking ne=
ar 100% of a CPU?
>
> --rich
>

Now that I look again, it seems that the btrfs-cleaner process is
still running. CPU isn't much of an issue on this box. Its a dual quad
E5620. 8 cores, 16 threads.
Looks like most of my load is wait from the cleaner process hammering
the disks. I deleted about 10 snapshots I think. Should this take 4
days to clean up from that?

Cpu0  :  0.0%us,  0.2%sy,  0.0%ni, 85.1%id, 14.7%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu1  :  0.0%us,  0.4%sy,  0.0%ni, 66.9%id, 32.6%wa,  0.0%hi,  0.1%si, =
 0.0%st
Cpu2  :  0.0%us,  0.2%sy,  0.0%ni, 88.7%id, 11.1%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu3  :  0.0%us,  0.1%sy,  0.0%ni, 96.7%id,  3.2%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu4  :  0.0%us,  0.2%sy,  0.0%ni, 92.3%id,  7.5%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu5  :  0.0%us,  0.1%sy,  0.0%ni, 97.6%id,  2.4%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu6  :  0.0%us,  0.1%sy,  0.0%ni, 98.5%id,  1.5%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni, 99.8%id,  0.2%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu8  :  0.0%us,  0.1%sy,  0.0%ni, 95.7%id,  4.3%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu9  :  0.0%us,  1.6%sy,  0.0%ni, 30.2%id, 68.2%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu10 :  0.0%us,  0.0%sy,  0.0%ni, 95.1%id,  4.8%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu11 :  0.0%us,  0.0%sy,  0.0%ni, 99.6%id,  0.4%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu12 :  0.0%us,  0.4%sy,  0.0%ni, 83.8%id, 15.7%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu13 :  0.0%us,  0.0%sy,  0.0%ni, 98.1%id,  1.8%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu14 :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.3%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu15 :  0.0%us,  0.0%sy,  0.0%ni, 99.8%id,  0.2%wa,  0.0%hi,  0.0%si, =
 0.0%st

Time: 12:24:01 AM
Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb              16.25     6.49 127.45 330.65  1173.03  3946.46
11.18    70.55  154.01   2.13  97.71

Time: 12:24:21 AM
Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               5.20     2.70 92.55 270.70   782.00  2795.20
9.85    70.12  189.42   2.69  97.85

Time: 12:24:41 AM
Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb               0.25    11.90  5.20 863.35    43.60  9391.60
10.86   144.84  168.01   1.15 100.00

Time: 12:25:01 AM
Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz
avgqu-sz   await  svctm  %util
sdb              17.50     0.60 204.35 49.70  1776.00   524.00
9.05    18.64   74.23   3.74  95.03

--=20
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
