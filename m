Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12899 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752984AbaBJSla (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 13:41:30 -0500
Message-ID: <52F91D53.5060902@fb.com>
Date: Mon, 10 Feb 2014 13:41:23 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Hugo Mills <hugo@carfax.org.uk>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com>	<20140210170606.GK6490@carfax.org.uk>	<CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>	<52F91A4A.4080807@fb.com> <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
In-Reply-To: <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/10/2014 01:36 PM, cwillu wrote:
> IMO, used should definitely include metadata, especially given that we
> inline small files.
>
> I can convince myself both that this implies that we should roll it
> into b_avail, and that we should go the other way and only report the
> actual used number for metadata as well, so I might just plead
> insanity here.
>

I could be convinced to do this.  So we have

total: (total disk bytes) / (raid multiplier)
used: (total used in data block groups) +
	(total used in metadata block groups)
avail: total - (total used in data block groups +
		total metadata block groups)

That seems like the simplest to code up.  Then we can argue about 
whether to use the total metadata size or just the used metadata size 
for b_avail.  Seem reasonable?

Josef
