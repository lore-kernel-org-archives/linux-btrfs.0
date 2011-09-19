From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: fix pages truncation in btrfs_ioctl_clone()
Date: Mon, 19 Sep 2011 11:07:14 +0800
Message-ID: <4E76B1E2.3070402@cn.fujitsu.com>
References: <4E731009.2030202@cn.fujitsu.com> <Pine.LNX.4.64.1109160934590.11043@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1109160934590.11043@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

>> Also move the function before locking extent state.
> 
> Hmm, any reason?  i_mutex protects us from a racing write(2), but what 
> about a racing mmap()?  e.g.
> 
> cloner: truncates dest pages
> writer: mmap -> page_mkwrite locks extent, creates new dirty page, unlocks
> cloner: locks extent, clones, unlocks extent
> 

(besides Chris' comments)

How can we avoid the race on dst file by locking src file extent state..

--
Li Zefan
