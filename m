Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428A948A8C6
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997702; cv=none; b=agWLLIZvffHHh3ho60xR/badTrr0RH+uM44KgMBtVJNYZNXcxU3Rqp/LpEyviEDfZv23J6QqjbFiC9LFZTH21aDNvkV2E14FkW4WYl/3D84tVuQ9xu9KB3wRSlNPNN6icQjs/EWY0R3Bur0eQrClCbAFgIfXLllV02GXXKE1fIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997702; c=relaxed/simple;
	bh=oskklBN/0+MkZ2YRWTYiy/bh6/jAfJYkDs1BJs9soK4=;
	h=To:Mime-Version:Content-Type:Cc:References:From:Date:In-Reply-To:
	 Subject:Message-Id; b=Q2SWKc9jlAKEJGd6miTbXnHJqY3ggdCFsRa/7X+jmJt0Drr9o4ahfekDeQESMkljz5y5VfXXVqFAnVpcKXRon0hSn9rSG0mFJATaz/e4Sd3oibinxLUQm1sDOFxrwQxEo+/y+9fh0vaayKuNSY8WW8EHNr7B9fP9sfLfKP/GarM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=EeM19PMT; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="EeM19PMT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789997688;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=x7FzZ/uTt+nwM8zey6wRE5yBAxxVXRO409QUqwJeRvw=;
 b=EeM19PMTxJuEIg5ZBN1MMjATtXYw9H4JvXCPg2jQ/DGclIt0n4iDLQLO/1YvB1ZuqC3ao6
 Tf+SViE+K9LWTdBOvZ4DFE6zMOz7fG5mq7/fzvP8gXuSQQU8N6JRg8KW0dBwkyJNMHUhYD
 z6PmiRJMhy+V7GtBGfSyFb73rjT8wniik3iHTxu8GaiiuLlpmOOfsZeuJnCtbXsvM1epQX
 HwBvJMw6ooUibyBcXWTJRW6LBbNzxcXIB6IYNz2CjcJ+9SgzK0kwxVQKZYGSL4S00gXtY9
 M8EFrc+Gw/lFMEHwQuvIBsZ9009mIP5xzmevT8miV6dHtSlwnrVjUhWqH9zGzg==
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
User-Agent: Mozilla Thunderbird
To: <dsterba@suse.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>, 
	"Richard Weinberger" <richard@nod.at>
Received: from [192.168.8.64] ([183.34.169.232]) by smtp.larksuite.com with ESMTPS; Mon, 21 Sep 2026 13:34:47 +0000
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com> <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io> <20260921131220.GE54722@twin.jikos.cz>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Date: Mon, 21 Sep 2026 21:34:41 +0800
X-Lms-Return-Path: <lba+26ab13277+21f32c+vger.kernel.org+zhudongjiang@fygo.io>
In-Reply-To: <20260921131220.GE54722@twin.jikos.cz>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
Message-Id: <3f752a53-9cbc-4f1c-8430-49ed505abd39@fygo.io>

=E5=9C=A8 2026/9/21 21:12, David Sterba =E5=86=99=E9=81=93:
> On Mon, Sep 21, 2026 at 04:36:51PM +0800, Dongjiang Zhu wrote:
>> =E5=9C=A8 2026/9/21 15:03, Qu Wenruo =E5=86=99=E9=81=93:
>>> [BUG]
>>> There is a bug report that a running qgroup rescan can fail a pm
>>> suspension:
>>>
>>>   [ T278489] Freezing remaining freezable tasks
>>>   [ T278489] Freezing remaining freezable tasks failed after 20.003 sec=
onds (0 tasks refusing to freeze, wq_busy=3D1):
>>>   [ T278489] Showing freezable workqueues that are still busy:
>>>   [...]
>>>   [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 active=3D1 refc=
nt=3D16
>>>   [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
>>>
>>> [CAUSE]
>>> Btrfs qgroup rescan is running in a workqueue, and when the fs is
>>> frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
>>>
>>> But a sleeping workload still counts as active for the workqueue until
>>> the workload exits.
>>>
>>> So the qgroup rescan item will sleep on the frozen fs, and fail the pm
>>> suspension.
>>>
>>> [FIX]
>>> I strongly doubt whether we should even use a workqueue for the qgroup
>>> rescan workload, a kthread would be a more suitable choice and can hand=
le
>>> fs and process freezing way better.
>>> But that will be a long term solution.
>>
>> Hi Qu,
>>
>> Thanks for working on this.
>>
>> I recently posted an RFC series addressing qgroup rescan lifecycle
>> issues around quota disable/enable, error cleanup, and remounts [1].
>>
>>  From the recent discussion, I got the impression that full qgroups
>> might be phased out or substantially reworked. Is that a fair
>> understanding?
>=20
> Do you have link to the dicussion? Phasing out current qgroups in the
> full mode would be a functionality loss and we don't have a replacement.
> On the design level, the qgroups are general enough to cover the COW
> design, sharing. The compression was originally intended but IIRC we
> don't account compressed extents separately.
>=20
> Reworking could happen, the performance hit of qgroups in full mode has
> been a problem since beginning, but I don't see any easy change there.
> If the sematics change we'd need to add another mode, like we have the
> simple quota mode.

Hi David,

I was referring to this discussion [1].

Perhaps I misunderstood Qu's comments about qgroups no longer being recomme=
nded.

Thanks for clarifying.

[1] https://lore.kernel.org/linux-btrfs/mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5d=
b853d61536@nod.at/T/

Thanks,
Dongjiang
