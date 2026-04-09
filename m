Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9B727281D
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 17:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756481; cv=none; b=gZnAaJTZP6Yj9rrZFcLc6OaRe4vSCO1NbPOW5noZo32r9HvR7ltv+xMci7Oh2f3mdEqOYWwVsBFICKfM19XI9dDFhUGSZ16oMZJ9vP0AWp4jtf5STS4ntjxGysGw7Cz6reTntqVfGY4sQTZrHChLoCzzlSJtkZ7EmXi9mvFrVp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756481; c=relaxed/simple;
	bh=lqGoEcZEjx2Fa0kYDwu5AtkXPdbPbXfKJUj9OKqc7TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OESWM2jJQ58ZyeOc2vXlEd5S85M7BJ5dNLq3j+anlCKibBy8X4jPaxZRLINzm7tyUkhMVws4k4DIfdti1l/3qtVmYEHYQXZv+S+xNUxHcjPFHDczV+BvW5ykElPlwLsqHCrNTZU6SGDWALSwhxkSrOd6v9WeF++tDYHlh29e55o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=rWVzxBgA; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tMU77jaU; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="rWVzxBgA";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tMU77jaU"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 830101D001B9;
	Thu,  9 Apr 2026 13:41:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Thu, 09 Apr 2026 13:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775756478; x=1775842878; bh=+0ZmZ4UlpO
	YB3sEly9+m0h8C3lcIn2Rx9QRXQQSeSSA=; b=rWVzxBgAQH4bUdNGUG76wS6qAp
	IDacRAE4d75BOQkRLf22H/I3Klpc0ttZm/9KdxHNTNXdMQcfnPI1Bgg8tIjt7oqj
	yE/EHbTQZ9/pjgNrjGN0UbsaB22o9l3gFooPJE8t6XoQWpxAGJtwm6d7vkutl8iS
	loVblDSdaD+XtipeVkrDeZFcSP2KUR9GqInmMYBxQhUPCdojviJg12MQNqFVT7aJ
	O4urVoZTtqX3CvoFt/RWxguGaEGmxaPxUK4BPyaSQN/shkB9nEZSHXbBi2VpDEyp
	Io/yS1g1VuLZSkrNGFzHt6IZGeyK95c3xI7WkERdRUbd4sPQWHqRFosf7Igg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775756478; x=1775842878; bh=+0ZmZ4UlpOYB3sEly9+m0h8C3lcIn2Rx9QR
	XQQSeSSA=; b=tMU77jaU9sRNhEFTz9eUMiBRD6ZJNY1/X6BjUkT0R0pEtdnsUtZ
	WFutsvRz6O3Cb5gys6CCsWgwbOgTRidOasODJwKSLJYxSztbCuq6J6DheSHOQoo7
	UTvB8sTUz+5Wj6OmMC2Gf7/I6uJ/Kt3vlzia+1I0UYxkDBIW827zzSxFonpgeqWV
	itMPvdwIM63FP2DqmrAcn1Jx7mgtkchW6FhUObZc7qg+HhmZtxYypzpRpXyAGsEw
	L/8XfrIhqr1i78EZm8yOYYcCN352bVbujLA0u1kdksnbReZRdg0jflLumCFsplIo
	OX/qiPPCHNLbykZwfQaBJbuNC21eTStM5tw==
X-ME-Sender: <xms:veTXaZhlkZNNlEL--19LSVpKNqffNHVW67uPjoKXylqN9gWWx9r-8g>
    <xme:veTXaUBx4sZQ-IYZxeujdENP10zFzFsLCYHxQjUOYvXnbiPwhKQTruwHzHhnGj2Rh
    HDnFucj2wzD60F9O0a921TAQ7HCXcJ3JCDhKFvhvJ_p2WpXnAoZ_hs>
X-ME-Received: <xmr:veTXaWuucjs7TH0HcKg3AKN2quX6-Rvht5cneebQEH9VQJX6uCZLDsQtsmmMVmbpZgEUlP-uhxhU4HFTrotQOSACTvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjeduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeefudeiuddvtefgledthfdutedtlefffffggeelfffhhf
    fhtdejudetvddttdeiueenucffohhmrghinhepvghmphhthidrmhhvpdhqvghmuhdrohhr
    ghdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehfughmrghnrghnrgeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdr
    ohhrgh
X-ME-Proxy: <xmx:veTXaZauBhUIBWK02Htmrh252PFk14WCggbn8_OHnP_csYohq6l3OA>
    <xmx:veTXaZWXweSjjU0Ji0EWq5gnijFBAzfUyinUApKwrRar52KdjrXuTg>
    <xmx:veTXad5TkeXR-I1ynWHWVpilF77Mk6eJfvu7fRQSCqr2EF9j1jdENg>
    <xmx:veTXaUjcdgAUDqOyo-cTBqKdQwo5A-tpy87cm0y0WBfuL80nTE8aJQ>
    <xmx:vuTXaWUNwGWZeLwLlNpZmOHad6v9agVoNwbfLNHr7WbiYVuWHEzaPhDj>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 13:41:17 -0400 (EDT)
Date: Thu, 9 Apr 2026 10:41:04 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix missing last_unlink_trans update when
 removing a directory
Message-ID: <20260409174104.GA803538@zen.localdomain>
References: <3f193ac4b0faadc24d718c3633f8c1a9c61a687c.1775747553.git.fdmanana@suse.com>
 <8c8eb0bb3fb3fe5ccb1ad60be1ded4c8c1e34b43.1775754827.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c8eb0bb3fb3fe5ccb1ad60be1ded4c8c1e34b43.1775754827.git.fdmanana@suse.com>

On Thu, Apr 09, 2026 at 06:19:23PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> When removing a directory we are not updating its last_unlink_trans field,
> which can result in incorrect fsync behaviour in case some one fsyncs the
> directory after it was removed because it's holding a file descriptor on
> it.
> 
> Example scenario:
> 
>    mkdir /mnt/dir1
>    mkdir /mnt/dir1/dir2
>    mkdir /mnt/dir3
> 
>    sync -f /mnt
> 
>    # Do some change to the directory and fsync it.
>    chmod 700 /mnt/dir1
>    xfs_io -c fsync /mnt/dir1
> 
>    # Move dir2 out of dir1 so that dir1 becomes empty.
>    mv /mnt/dir1/dir2 /mnt/dir3/
> 
>    open fd on /mnt/dir1
>    call rmdir(2) on path "/mnt/dir1"
>    fsync fd
> 
>    <trigger power failure>
> 
> When attempting to mount the filesystem, the log replay will fail with
> an -EIO error and dmesg/syslog has the following:
> 
>    [445771.626482] BTRFS info (device dm-0): first mount of filesystem 0368bbea-6c5e-44b5-b409-09abe496e650
>    [445771.626486] BTRFS info (device dm-0): using crc32c checksum algorithm
>    [445771.627912] BTRFS info (device dm-0): start tree-log replay
>    [445771.628335] page: refcount:2 mapcount:0 mapping:0000000061443ddc index:0x1d00 pfn:0x7072a5
>    [445771.629453] memcg:ffff89f400351b00
>    [445771.629892] aops:btree_aops [btrfs] ino:1
>    [445771.630737] flags: 0x17fffc00000402a(uptodate|lru|private|writeback|node=0|zone=2|lastcpupid=0x1ffff)
>    [445771.632359] raw: 017fffc00000402a fffff47284d950c8 fffff472907b7c08 ffff89f458e412b8
>    [445771.633713] raw: 0000000000001d00 ffff89f6c51d1a90 00000002ffffffff ffff89f400351b00
>    [445771.635029] page dumped because: eb page dump
>    [445771.635825] BTRFS critical (device dm-0): corrupt leaf: root=5 block=30408704 slot=10 ino=258, invalid nlink: has 2 expect no more than 1 for dir
>    [445771.638088] BTRFS info (device dm-0): leaf 30408704 gen 10 total ptrs 17 free space 14878 owner 5
>    [445771.638091] BTRFS info (device dm-0): refs 4 lock_owner 0 current 3581087
>    [445771.638094] 	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
>    [445771.638097] 		inode generation 3 transid 9 size 16 nbytes 16384
>    [445771.638098] 		block group 0 mode 40755 links 1 uid 0 gid 0
>    [445771.638100] 		rdev 0 sequence 2 flags 0x0
>    [445771.638102] 		atime 1775744884.0
>    [445771.660056] 		ctime 1775744885.645502983
>    [445771.660058] 		mtime 1775744885.645502983
>    [445771.660060] 		otime 1775744884.0
>    [445771.660062] 	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
>    [445771.660064] 		index 0 name_len 2
>    [445771.660066] 	item 2 key (256 DIR_ITEM 1843588421) itemoff 16077 itemsize 34
>    [445771.660068] 		location key (259 1 0) type 2
>    [445771.660070] 		transid 9 data_len 0 name_len 4
>    [445771.660075] 	item 3 key (256 DIR_ITEM 2363071922) itemoff 16043 itemsize 34
>    [445771.660076] 		location key (257 1 0) type 2
>    [445771.660077] 		transid 9 data_len 0 name_len 4
>    [445771.660078] 	item 4 key (256 DIR_INDEX 2) itemoff 16009 itemsize 34
>    [445771.660079] 		location key (257 1 0) type 2
>    [445771.660080] 		transid 9 data_len 0 name_len 4
>    [445771.660081] 	item 5 key (256 DIR_INDEX 3) itemoff 15975 itemsize 34
>    [445771.660082] 		location key (259 1 0) type 2
>    [445771.660083] 		transid 9 data_len 0 name_len 4
>    [445771.660084] 	item 6 key (257 INODE_ITEM 0) itemoff 15815 itemsize 160
>    [445771.660086] 		inode generation 9 transid 9 size 8 nbytes 0
>    [445771.660087] 		block group 0 mode 40777 links 1 uid 0 gid 0
>    [445771.660088] 		rdev 0 sequence 2 flags 0x0
>    [445771.660089] 		atime 1775744885.641174097
>    [445771.660090] 		ctime 1775744885.645502983
>    [445771.660091] 		mtime 1775744885.645502983
>    [445771.660105] 		otime 1775744885.641174097
>    [445771.660106] 	item 7 key (257 INODE_REF 256) itemoff 15801 itemsize 14
>    [445771.660107] 		index 2 name_len 4
>    [445771.660108] 	item 8 key (257 DIR_ITEM 2676584006) itemoff 15767 itemsize 34
>    [445771.660109] 		location key (258 1 0) type 2
>    [445771.660110] 		transid 9 data_len 0 name_len 4
>    [445771.660111] 	item 9 key (257 DIR_INDEX 2) itemoff 15733 itemsize 34
>    [445771.660112] 		location key (258 1 0) type 2
>    [445771.660113] 		transid 9 data_len 0 name_len 4
>    [445771.660114] 	item 10 key (258 INODE_ITEM 0) itemoff 15573 itemsize 160
>    [445771.660115] 		inode generation 9 transid 10 size 0 nbytes 0
>    [445771.660116] 		block group 0 mode 40755 links 2 uid 0 gid 0
>    [445771.660117] 		rdev 0 sequence 0 flags 0x0
>    [445771.660118] 		atime 1775744885.645502983
>    [445771.660119] 		ctime 1775744885.645502983
>    [445771.660120] 		mtime 1775744885.645502983
>    [445771.660121] 		otime 1775744885.645502983
>    [445771.660122] 	item 11 key (258 INODE_REF 257) itemoff 15559 itemsize 14
>    [445771.660123] 		index 2 name_len 4
>    [445771.660124] 	item 12 key (258 INODE_REF 259) itemoff 15545 itemsize 14
>    [445771.660125] 		index 2 name_len 4
>    [445771.660126] 	item 13 key (259 INODE_ITEM 0) itemoff 15385 itemsize 160
>    [445771.660127] 		inode generation 9 transid 10 size 8 nbytes 0
>    [445771.660128] 		block group 0 mode 40755 links 1 uid 0 gid 0
>    [445771.660129] 		rdev 0 sequence 1 flags 0x0
>    [445771.660130] 		atime 1775744885.645502983
>    [445771.660130] 		ctime 1775744885.645502983
>    [445771.660131] 		mtime 1775744885.645502983
>    [445771.660132] 		otime 1775744885.645502983
>    [445771.660133] 	item 14 key (259 INODE_REF 256) itemoff 15371 itemsize 14
>    [445771.660134] 		index 3 name_len 4
>    [445771.660135] 	item 15 key (259 DIR_ITEM 2676584006) itemoff 15337 itemsize 34
>    [445771.660136] 		location key (258 1 0) type 2
>    [445771.660137] 		transid 10 data_len 0 name_len 4
>    [445771.660138] 	item 16 key (259 DIR_INDEX 2) itemoff 15303 itemsize 34
>    [445771.660139] 		location key (258 1 0) type 2
>    [445771.660140] 		transid 10 data_len 0 name_len 4
>    [445771.660144] BTRFS error (device dm-0): block=30408704 write time tree block corruption detected
>    [445771.661650] ------------[ cut here ]------------
>    [445771.662358] WARNING: fs/btrfs/disk-io.c:326 at btree_csum_one_bio+0x217/0x230 [btrfs], CPU#8: mount/3581087
>    [445771.663588] Modules linked in: btrfs f2fs xfs (...)
>    [445771.671229] CPU: 8 UID: 0 PID: 3581087 Comm: mount Tainted: G        W           7.0.0-rc6-btrfs-next-230+ #2 PREEMPT(full)
>    [445771.672575] Tainted: [W]=WARN
>    [445771.672987] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-0-gea1b7a073390-prebuilt.qemu.org 04/01/2014
>    [445771.674460] RIP: 0010:btree_csum_one_bio+0x217/0x230 [btrfs]
>    [445771.675222] Code: 89 44 24 (...)
>    [445771.677364] RSP: 0018:ffffd23882247660 EFLAGS: 00010246
>    [445771.678029] RAX: 0000000000000000 RBX: ffff89f6c51d1a90 RCX: 0000000000000000
>    [445771.678975] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff89f406020000
>    [445771.679983] RBP: ffff89f821204000 R08: 0000000000000000 R09: 00000000ffefffff
>    [445771.680905] R10: ffffd23882247448 R11: 0000000000000003 R12: ffffd23882247668
>    [445771.681978] R13: ffff89f458e40fc0 R14: ffff89f737f4f500 R15: ffff89f737f4f500
>    [445771.682912] FS:  00007f0447a98840(0000) GS:ffff89fb9771d000(0000) knlGS:0000000000000000
>    [445771.684393] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    [445771.685230] CR2: 00007f0447bf1330 CR3: 000000017cb02002 CR4: 0000000000370ef0
>    [445771.686273] Call Trace:
>    [445771.686646]  <TASK>
>    [445771.686969]  btrfs_submit_bbio+0x83f/0x860 [btrfs]
>    [445771.687750]  ? write_one_eb+0x28f/0x340 [btrfs]
>    [445771.688428]  btree_writepages+0x2e3/0x550 [btrfs]
>    [445771.689180]  ? kmem_cache_alloc_noprof+0x12a/0x490
>    [445771.689963]  ? alloc_extent_state+0x19/0x120 [btrfs]
>    [445771.690801]  ? kmem_cache_free+0x135/0x380
>    [445771.691328]  ? preempt_count_add+0x69/0xa0
>    [445771.691831]  ? set_extent_bit+0x252/0x8e0 [btrfs]
>    [445771.692468]  ? xas_load+0x9/0xc0
>    [445771.692873]  ? xas_find+0x14d/0x1a0
>    [445771.693304]  do_writepages+0xc6/0x160
>    [445771.693756]  filemap_writeback+0xb8/0xe0
>    [445771.694274]  btrfs_write_marked_extents+0x61/0x170 [btrfs]
>    [445771.694999]  btrfs_write_and_wait_transaction+0x4e/0xc0 [btrfs]
>    [445771.695818]  btrfs_commit_transaction+0x5c8/0xd10 [btrfs]
>    [445771.696530]  ? kmem_cache_free+0x135/0x380
>    [445771.697120]  ? release_extent_buffer+0x34/0x160 [btrfs]
>    [445771.697786]  btrfs_recover_log_trees+0x7be/0x7e0 [btrfs]
>    [445771.698525]  ? __pfx_replay_one_buffer+0x10/0x10 [btrfs]
>    [445771.699206]  open_ctree+0x11e5/0x1810 [btrfs]
>    [445771.699776]  btrfs_get_tree.cold+0xb/0x162 [btrfs]
>    [445771.700463]  ? fscontext_read+0x165/0x180
>    [445771.701146]  ? rw_verify_area+0x50/0x180
>    [445771.701866]  vfs_get_tree+0x25/0xd0
>    [445771.702491]  vfs_cmd_create+0x59/0xe0
>    [445771.703125]  __do_sys_fsconfig+0x303/0x610
>    [445771.703603]  do_syscall_64+0xe9/0xf20
>    [445771.703974]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    [445771.704700] RIP: 0033:0x7f0447cbd4aa
>    [445771.705108] Code: 73 01 c3 (...)
>    [445771.707263] RSP: 002b:00007ffc4e528318 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
>    [445771.708107] RAX: ffffffffffffffda RBX: 00005561585d8c20 RCX: 00007f0447cbd4aa
>    [445771.708931] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
>    [445771.709744] RBP: 00005561585d9120 R08: 0000000000000000 R09: 0000000000000000
>    [445771.710674] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>    [445771.711477] R13: 00007f0447e4f580 R14: 00007f0447e5126c R15: 00007f0447e36a23
>    [445771.712277]  </TASK>
>    [445771.712541] ---[ end trace 0000000000000000 ]---
>    [445771.713382] BTRFS error (device dm-0): error while writing out transaction: -5
>    [445771.714679] BTRFS warning (device dm-0): Skipping commit of aborted transaction.
>    [445771.715562] BTRFS error (device dm-0 state A): Transaction aborted (error -5)
>    [445771.716459] BTRFS: error (device dm-0 state A) in cleanup_transaction:2068: errno=-5 IO failure
>    [445771.717936] BTRFS error (device dm-0 state EA): failed to recover log trees with error: -5
>    [445771.719681] BTRFS error (device dm-0 state EA): open_ctree failed: -5
> 
> The problem is that such a fsync should have result in a fallback to a
> transaction commit, but that did not happen because through the
> btrfs_rmdir() we never update the directory's last_unlink_trans field.
> Any inode that had a link removed must have its last_unlink_trans updated
> to the ID of transaction used for the operation, otherwise fsync and log
> replay will not work correctly.
> 
> btrfs_rmdir() calls btrfs_unlink_inode() and through that call chain we
> never call btrfs_record_unlink_dir() in order to update last_unlink_trans.
> However btrfs_unlink(), which is used for unlinking regular files, calls
> btrfs_record_unlink_dir() and then calls btrfs_unlink_inode(). So fix
> this by moving the call to btrfs_record_unlink_dir() from btrfs_unlink()
> to btrfs_unlink_inode().
> 
> A test case for fstests will follow soon.
> 
> Reported-by: Slava0135 <slava.kovalevskiy.2014@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAAJYhww5ov62Hm+n+tmhcL-e_4cBobg+OWogKjOJxVUXivC=MQ@mail.gmail.com/
> CC: stable@vger.kernel.org
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.
Reviewed-by: Boris Burkov <boris@bur.io>

> ---
> 
> V2: Move the btrfs_record_unlink_dir() to happen before calling
>     __btrfs_unlink_inode().
> 
>  fs/btrfs/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 40474014c03f..2b504e3242b2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4506,6 +4506,8 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  {
>  	int ret;
>  
> +	btrfs_record_unlink_dir(trans, dir, inode, false);
> +
>  	ret = __btrfs_unlink_inode(trans, dir, inode, name, NULL);
>  	if (!ret) {
>  		drop_nlink(&inode->vfs_inode);
> @@ -4549,9 +4551,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
>  		goto fscrypt_free;
>  	}
>  
> -	btrfs_record_unlink_dir(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
> -				false);
> -
>  	ret = btrfs_unlink_inode(trans, BTRFS_I(dir), BTRFS_I(d_inode(dentry)),
>  				 &fname.disk_name);
>  	if (ret)
> -- 
> 2.47.2
> 
