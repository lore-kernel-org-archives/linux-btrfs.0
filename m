Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [46.38.247.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DE353A65;
	Thu, 10 Sep 2026 10:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.38.247.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037306; cv=none; b=t9f8KzAy1aCfuZoLjdSt8DuTwa4plqqmxVcLoC4A/NOP7WSyioc5x1SFzUbd+V3vPINPJVDZG3qdqOyYesBiBVQLk5Ouk7AuTRQCDUyjOxT9YkJtkdr61x7cU44SkoKQutFnYRu4IiAtptiYF3V+jl4CZjQkVuemRGQl7I3sfi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037306; c=relaxed/simple;
	bh=enPl0P4IRL71cTLXLsRDVjv9kocJZzZNibDFU0sramE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djKNZFlz9HwK5K/zKIN/dgY20YbumhwJ7RcPl/thmIh9/3VdFiWX50uCN8EIcp20/tA6y85S6BAKOsi91XhfhU2p70uNDlkk8NU7/ydM4QsyXzaCsAymy6Jo8rqHkZBL7mqG+CCe2VKczI61m7o4Bf0bStASwnyo9OhvgAlcJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=DhVqPvs6; arc=none smtp.client-ip=46.38.247.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="DhVqPvs6"
Received: from mors-relay-8404.netcup.net (localhost [127.0.0.1])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4hgZ1C1N4Yz8H1p;
	Thu, 10 Sep 2026 12:39:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1789036767;
	bh=enPl0P4IRL71cTLXLsRDVjv9kocJZzZNibDFU0sramE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DhVqPvs6cyjS4lyj3w9Buz0NK5yjy5D+fBvXvg7neRpxvRan9A1HLiOqITg/Hxray
	 /SFTxptgZLXfdLo/Txg1g90OtwhpM/GPkmfk+nuaHrJo8RV8X9sCwKhm/0IB9+V/6w
	 KsRlcUYKtwTwAb/l0rRd7sdNUtoM6d+MTnQpX6WSJNa5+3UH0ZYRQH8BRGHq9LVz6+
	 q/C8xrrgWHqZmZOBXxdw1U6mWU5q85kx7fYD7MJpEnf0a0FjtG0n7cjwxKiVI9PEbd
	 n0t0fEFNnxOcXKOrHLaX4COuj45bkNygOd/fLRgt4irSBjP49JHeSA9vJSlcGizUk1
	 EnYvfj3ECWUIA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8404.netcup.net (Postfix) with ESMTPS id 4hgZ1C0gHSz4xPV;
	Thu, 10 Sep 2026 12:39:27 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4hgZ1B41q5z8sZh;
	Thu, 10 Sep 2026 12:39:26 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id D08EE5FB28;
	Thu, 10 Sep 2026 12:39:25 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <4c5117f7-1ddd-4596-8917-da47379506fd@leemhuis.info>
Date: Thu, 10 Sep 2026 12:39:25 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: commit 108cc873398932af589c295f78c348513b8d70d9 breaks
 update-grub on btrfs root filesystem
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
 Alex Romosan <aromosan@gmail.com>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: 
 <CAKLYgeL7nrA4nXcewdv9Fqg_s=3GS=vmoypnEiZBKQ7rySZFuQ@mail.gmail.com>
 <20260909002506.GF9053@twin.jikos.cz>
 <6a5c2d41-b10b-44cb-969e-b4a56d002ceb@gmx.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <6a5c2d41-b10b-44cb-969e-b4a56d002ceb@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <178903676617.1442824.794382640336511039@mxe9fb.netcup.net>
X-NC-CID: rK69uwty1yMF2rMjLSwTqshdAbVjesipN/pDURYAfQxY8znkUgM=

On 9/9/26 03:13, Qu Wenruo wrote:
> 在 2026/9/9 09:55, David Sterba 写道:
>> On Tue, Sep 08, 2026 at 11:59:43PM +0200, Alex Romosan wrote:
>>>
>>> [...] Since version 7.3-rc1 i haven't been able to to a grub-update, 
>>> instead i get this error:
>>>
>>> /usr/sbin/grub-probe: error: cannot find a device for / (is /dev
>>> mounted?).
>>>
>>> 7.2 is fine. a git-bisect identified commit
>>> 108cc873398932af589c295f78c348513b8d70d9 as being the culprit.
>>> reverting this commit from 7.3-rc2 allowed me to run grub-update
>>> again.
>>>
>>> this is not the first time i reported grub-update being broken on
>>> btrfs. i reported exactly the same problem on jan 8, 2024
>>> (https://lkml.iu.edu/hypermail/linux/kernel/2401.1/00596.html). maybe
>>> the discussion that followed would help come up with a fix that will
>>> make everybody happy.
>>
>> I remember debugging that one, https://bugzilla.kernel.org/
>> show_bug.cgi?id=218353
>> Reverting 108cc8733989 ("btrfs: fix a lockdep caused by path resolution
>> during device scan") would bring back the lockdep warning and there is a
>> locking problem.
>>
>> The commit says it's fixing 2e8b6bc0ab41 ("btrfs: avoid unnecessary
>> device path update for the same device"), the difference is in lines
>>
>> (https://bugzilla.suse.com/show_bug.cgi?id=1230641)
>>
>> -       } else if (!device->name || strcmp(device->name->str, path)) {
>> +    } else if (!device->name || !is_same_device(device, path)) {
>>
>> Which gets changed to (by 108cc8733989):
>>
>> -       } else if (!device->name || !is_same_device(device, path)) {
>> +       } else if (!device->name || device->devt != path_devt) {
>>
>> Each change is reaction to a bug, I don't see a clear fix which will
>> make it work in all cases.
> 
> And I want to add that, the previous path based comparison is also
> problematic for namespaces/weird block device names.
> 
> Although not common, it's definitely possible to map weird block file
> name into a namespace.
> 
> Thus the path based comparison is not reliable in the first place, no to
> mention the later lockdep problems.

Well, but our #1 is "no regressions". And the recent change while fixing
bugs clearly causes one, as Alex's report is afaics at least the third
about it; the two earlier ones can be found here:

https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/
https://lore.kernel.org/linux-btrfs/018a9738-1d4a-43a0-9352-a56d1e541364@gmail.com/
Plus a repost of the latter here:
https://lore.kernel.org/linux-btrfs/dfbe1e27-dab8-4d55-8cf3-0b28eeac5df4@gmail.com/

Exceptions to our #1 rule are rare. They, for example, are made when we
had to fix a vulnerability and tried hard to do so without breaking
something but in the end had to bite the bullet. Is this such a case?

Because if not, it looks more like a situation where Linus would prefer
to live with known problems, as earlier statements from him show:
https://www.kernel.org/doc/html/latest/process/handling-regressions.html#on-back-and-forth

But it's easy to misunderstand things from my outside position, which is
why I'm asking.

Ciao, Thorsten
