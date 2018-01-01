Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:57724 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbeAATxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jan 2018 14:53:41 -0500
Date: Mon, 1 Jan 2018 22:53:14 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V3] Btrfs: enchanse raid1/10 balance heuristic
Message-ID: <20180101225314.340c53e7@xps.localdomain>
In-Reply-To: <20171231002902.70599c8d@demfloro.ru>
References: <20171230203204.13151-1-nefelim4ag@gmail.com>
        <20171231002902.70599c8d@demfloro.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/UmE1t/TmenE+t9pJWbRrhCS"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/UmE1t/TmenE+t9pJWbRrhCS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, 31 Dec 2017 00:29:11 +0300
Dmitrii Tcvetkov <demfloro@demfloro.ru> wrote:

> On Sat, 30 Dec 2017 23:32:04 +0300
> Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 
> > Currently btrfs raid1/10 balancer balance requests to mirrors,
> > based on pid % num of mirrors.
> > 
> > Make logic understood:
> >  - if one of underline devices are non rotational
> >  - Queue leght to underline devices
> > 
> > By default try use pid % num_mirrors guessing, but:
> >  - If one of mirrors are non rotational, repick optimal to it
> >  - If underline mirror have less queue leght then optimal,
> >    repick to that mirror
> > 
> > For avoid round-robin request balancing,
> > lets round down queue leght:
> >  - By 8 for rotational devs
> >  - By 2 for all non rotational devs
> > 
> > Changes:
> >   v1 -> v2:
> >     - Use helper part_in_flight() from genhd.c
> >       to get queue lenght
> >     - Move guess code to guess_optimal()
> >     - Change balancer logic, try use pid % mirror by default
> >       Make balancing on spinning rust if one of underline devices
> >       are overloaded
> >   v2 -> v3:
> >     - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
> > 
> > Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>  
> 
> Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
> 
Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>

Benchmark summary (arithmetic mean of 3 runs):
		Mainline		Patch
--------------------------------------------------------------
RAID1	|	18.9 MiB/s	|	26.5 MiB/s
RAID10	|	30.7 MiB/s	|	30.7 MiB/s


fio configuration:
[global]                                                                                                                                                                   
ioengine=libaio
buffered=0
direct=1
bssplit=32k/100
size=8G
directory=/mnt/
iodepth=16
time_based
runtime=900

[test-fio]
rw=randread

All tests were run on 4 HDD btrfs filesystem in a VM with 4 Gb
of ram on idle host. Full results attached to the email.

--MP_/UmE1t/TmenE+t9pJWbRrhCS
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=results.tar.gz

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

--MP_/UmE1t/TmenE+t9pJWbRrhCS--
