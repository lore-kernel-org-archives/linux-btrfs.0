Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41130 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750729AbaJQUcs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 16:32:48 -0400
Message-ID: <54417CEB.9020003@fb.com>
Date: Fri, 17 Oct 2014 16:32:43 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Leonidas Spyropoulos <artafinde@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ccache on btrfs
References: <2700CF0B-F340-44F7-A4D6-0C5FF05CCD81@gmail.com> <CAGqmi7751HOLJ5xU+NfoZSjTQhgYME-9b36hgJt0oG6w+Ft-CA@mail.gmail.com> <20141017192438.GA20983@sune>
In-Reply-To: <20141017192438.GA20983@sune>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/17/2014 03:24 PM, Leonidas Spyropoulos wrote:
> On 17/10/14, Timofey Titovets wrote:
>> i use ccache and often compile linux from git,
>> I don't catch any errors with it.
>>
> Interesting, I re-enabled ccache on an ext4 partition (HDD) and worked
> fine. So I suspect it's something to do with btrfs and SSD. My mount
> options are:
> /dev/sda3 on /home type btrfs (rw,relatime,ssd,discard,nospace_cache)
>
> The problem is that I can't get hold of kernel panic since it's not in
> the journal [1]. I don't know a way to get hold of the kernel panic log
> to help anyway.
>
> What would it be useful to debug it?

Setup netconsole, you can set it to go to a different box and then on 
that box run

nc -lu -p 514 > out.txt

and then reproduce the panic.  If you are using fedora you can install 
netconsole and edit /etc/sysconfig/netconsole and set SYSLOGADDR=<your 
other boxes address>.  Thanks,

Josef

