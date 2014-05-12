Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22122 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbaELPWW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 11:22:22 -0400
Message-ID: <5370E724.1010401@fb.com>
Date: Mon, 12 May 2014 11:22:12 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>, <linux-btrfs@vger.kernel.org>
CC: Abbas <mickylmartin@gmail.com>
Subject: Re: Sending incremental backup causes deadlock (3.14.3)
References: <CAKAA-n=_jMyWFbfcGvMsMDJg3t7VpRegDDDybEeQ5oxof8graA@mail.gmail.com> <536D0ED3.2050602@fb.com> <1718079.d2fxXYZyoQ@quad>
In-Reply-To: <1718079.d2fxXYZyoQ@quad>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/10/2014 04:04 AM, Chris Samuel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi Josef,
>
> On Fri, 9 May 2014 01:22:27 PM Josef Bacik wrote:
>
>> Known problem, fixed in 3.15-rc1.  Thanks,
>
> Is the fix suitable for -stable too?
>

Unfortunately no, it's too big.  I had thought about shoving it back but 
it's simply too complicated and has a lot of other patches that go along 
with it to fix other things.  Thanks,

Josef

