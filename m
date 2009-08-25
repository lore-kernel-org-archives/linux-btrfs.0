From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Re: [PATCH]Re: The first character disappears
Date: Tue, 25 Aug 2009 11:04:46 +0300
Message-ID: <bcf98daa0908250104j199d6e7ey705cc3b9913a5bbd@mail.gmail.com>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
	 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
	 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
	 <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
	 <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
	 <bcf98daa0908240942l1f2ad95v609321409434801c@mail.gmail.com>
	 <Pine.LNX.4.64.0908240956500.2289@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Atila <atila.alr@dpf.gov.br>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0908240956500.2289@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/24 Sage Weil <sage@newdream.net>:
>
> Can you tell me if the change below fixes the problem?
>
No. Freshly created filesystem with compress:

htpc linux-2.6_copy # git status
error: bad index file sha1 signature
fatal: index file corrupt
