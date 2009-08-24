From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Re: [PATCH]Re: The first character disappears
Date: Mon, 24 Aug 2009 17:22:23 +0300
Message-ID: <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
	 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
	 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
	 <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Atila <atila.alr@dpf.gov.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ok, the first problem is fixed but after bcp
git status
error: bad index file sha1 signature
fatal: index file corrupt

Way to reproduce:

htpc 17:07 masu >git clone /usr/src/linux-2.6/
Initialized empty Git repository in /mnt/btrfs/masu/linux-2.6/.git/
Checking out files: 100% (29110/29110), done.
htpc 17:08 masu >cd linux-2.6/
htpc 17:08 linux-2.6 >git status
# On branch master
nothing to commit (working directory clean)

htpc 17:08 linux-2.6 >cd ..
htpc 17:08 masu >/tmp/btrfs-progs-unstable/bcp linux-2.6/ linux-2.6_copy
htpc 17:09 masu >cd linux-2.6_copy
htpc 17:09 linux-2.6_copy >git status
error: bad index file sha1 signature
fatal: index file corrupt


2009/8/24 Markus Suvanto <markus.suvanto@gmail.com>:
> After this patch against the latest
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> bcp don't eat the first character anymore, thanks :)
>
>
> 2009/8/24 Atila <atila.alr@dpf.gov.br>:
>> *
>> Signed-off-by: Atila <atila.alr@dpf.gov.br>
>> ---
