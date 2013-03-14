Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55966 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab3CNJsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 05:48:53 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Debian 3.7.1 BTRFS crash
Date: Thu, 14 Mar 2013 10:48:47 +0100
Cc: =?utf-8?q?J=C3=A9r=C3=B4me_Poulin?= <jeromepoulin@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>, russell@coker.com.au
References: <201303131238.33692.russell@coker.com.au> <513FDE67.1050907@redhat.com> <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com> (sfid-20130313_100808_915882_684A4123)
In-Reply-To: <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303141048.48180.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jérôme,

Am Mittwoch, 13. März 2013 schrieb Jérôme Poulin:
> On Tue, Mar 12, 2013 at 10:03 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > [   37.176790] BTRFS error (device dm-0) in __btrfs_free_extent:5143:
> > IO failure [   37.176791] btrfs is forced readonly
> > [   37.176793] btrfs: run_one_delayed_ref returned -5
> 
> It seems the SSD has bad blocks now, BTRFS seems to abuse SSD disks, I
> burnt 1 SSD disk and 2 USB flash drive since I'm using BTRFS, in about
> 2 months for each. ddrescue'ing the SSD would probably give better
> chances of recovery and give BTRFS/btrfsck a chance to write correctly
> to the newly copied image.

Well, the Intel SSD 320 in this ThinkPad T520 so far didn´t seem to notice
any significant abuse due to BTRFS in use:

smartctl-a-2013-03-14
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       5250
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       202408
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203778

Above value has always been in that range… according to a PDF from Intel the 
Media_Wearout_Indicator below is important.

233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       202408


I have about 20 GB / on BTRFS since the beginning. Thats almost 2 years now.

Now I also have 200GB /home on BTRFS, since a month or two. Granted this is
more data, but unless proven by observed I/O patterns or so, I suggest
being careful with suggestions that BTRFS abuses SSD disks out of just your
own experience and suggest to ask it as a question in case you do not know
for sure.

According to my irregular data points I also see no significant increase in
wear out after I switched BTRFS to /home although it is a bit premature to
say for sure - I will continue to have a look at it:

martin@merkaba:~/Computer/Merkaba/Intel SSD 320> for F in $(ls smartctl*) ; do echo "$F" | cut -c1-21 ; egrep "(Wear|Host_Writes|Erase_Fail_Count|
Power_On_Hours)" "$F" ; done
smartctl-a-2011-05-19
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       0
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
smartctl-a-2011-05-19
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       1
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
smartctl-a-2011-06-23
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       324
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19158
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203342
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19158
smartctl-a-2011-06-23
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       324
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19158
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203342
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19158
smartctl-a-2011-06-23
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       325
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19160
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203342
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19160
smartctl-a-2011-06-23
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       320
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       0
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19041
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203342
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       19041
smartctl-a-2011-12-16
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       271

Mow thats funny. Intel SSD went back in time? From 325 to 271 power on
hours in half year. I knew I had a time machine somewhere. I just forgot
where it is. :)

172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169

First occurence with erase failures. But didn´t raise after then.

No other error related occurences in other values so far :)

225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       66757
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203450
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       66757
smartctl-a-2011-12-16
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       271
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       66759
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203450
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       66759
smartctl-a-2011-12-16
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       271
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       66757
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203450
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       66757
smartctl-a-2012-07-19
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2444
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       128105
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       314
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       128105
smartctl-a-2012-07-19
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2443
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       127984
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       314
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       127984
smartctl-a-2012-07-30
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2582
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       131072
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203604
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       131072
smartctl-a-2012-12-02
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       4023
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       170107
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203703
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       170107
smartctl-a-2013-02-22
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       5010
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       198165
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203768
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       198165
smartctl-a-2013-02-22
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       5010
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       198163
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203768
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       198163
smartctl-a-2013-03-14
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       5250
172 Erase_Fail_Count        0x0032   100   100   000    Old_age   Always       -       169
225 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       202408
226 Workld_Media_Wear_Indic 0x0032   100   100   000    Old_age   Always       -       2203778
233 Media_Wearout_Indicator 0x0032   100   100   000    Old_age   Always       -       0
241 Host_Writes_32MiB       0x0032   100   100   000    Old_age   Always       -       202408

More than one data point on one day, is before and after self tests.

Basically the wear out related values didn´t change much at all. The indicicative
Media_Wearout_Indicitor didn´t change at all.

I leave about 20 GB of the 300 GB free at most times, according to a paper
from Intel this helps long time performance and from my understanding of
SSD workings it also helps long evity.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
