Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27443 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750775AbaJOUUm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 16:20:42 -0400
Message-ID: <543ED6FF.1080501@fb.com>
Date: Wed, 15 Oct 2014 16:20:15 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>
CC: Juan Orti Alcaine <juan.orti@miceliux.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
References: <543D555B.50708@pobox.com>	<eff13bd09ee6883785a4be3ab005886b@miceliux.com>	<543E7ACC.8080001@fb.com>	<f9840abeffb3a13578c3358a9e6cfec0@miceliux.com>	<543E8510.8020000@fb.com> <CAGfcS_moK9JLoz=nb54iNb_LCu3rtgBkYLkHLceT8eaiLJsL9g@mail.gmail.com>
In-Reply-To: <CAGfcS_moK9JLoz=nb54iNb_LCu3rtgBkYLkHLceT8eaiLJsL9g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/15/2014 03:30 PM, Rich Freeman wrote:
> On Wed, Oct 15, 2014 at 10:30 AM, Josef Bacik <jbacik@fb.com> wrote:
>> We've found it, the Fedora guys are reverting the bad patch now, we'll get
>> the fix sent back to stable shortly.  Sorry about that.
>
> After reverting this commit, can the bad snapshots be
> deleted/repaired/etc without wiping and restoring the entire
> filesystem?  Copying 2.3TB of data isn't a particularly fast
> operation...
>

I would certainly like to make fsck repair this sort of problem, let me 
reproduce the corruption locally and then make fsck fix it and then you 
can use that.  Thanks,

Josef

