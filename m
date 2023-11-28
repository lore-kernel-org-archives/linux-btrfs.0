Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from shin.romanrm.net (shin.romanrm.net [146.185.199.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D80CF4
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Nov 2023 12:09:28 -0800 (PST)
Received: from nvm (nvm.home.romanrm.net [IPv6:fd39::101])
	by shin.romanrm.net (Postfix) with SMTP id 8B8A23F3C3;
	Tue, 28 Nov 2023 20:09:17 +0000 (UTC)
Date: Wed, 29 Nov 2023 01:09:13 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <wqu@suse.com>
Cc: Hector Martin <marcan@marcan.st>, Josef Bacik <josef@toxicpanda.com>,
 Neal Gompa <neal@gompa.dev>, Linux BTRFS Development
 <linux-btrfs@vger.kernel.org>, Anand Jain <anand.jain@oracle.com>, Qu
 Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.cz>, Sven Peter
 <sven@svenpeter.dev>, Davide Cavalca <davide@cavalca.name>, Jens Axboe
 <axboe@fb.com>, Asahi Lina <lina@asahilina.net>, Asahi Linux
 <asahi@lists.linux.dev>
Subject: Re: [PATCH v4 0/1] Enforce 4k sectorize by default for mkfs
Message-ID: <20231129010913.295c0fa9@nvm>
In-Reply-To: <f229058e-4f5d-4bd0-9016-41b133688443@suse.com>
References: <20231116160235.2708131-1-neal@gompa.dev>
 <20231127160705.GC2366036@perftesting>
 <fb78d997-cb99-4b98-8042-bdcdbff22b88@marcan.st>
 <f229058e-4f5d-4bd0-9016-41b133688443@suse.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Nov 2023 06:27:26 +1030
Qu Wenruo <wqu@suse.com> wrote:

> > Reminder that the Raspberry Pi 5 is also shipping with 16K pages by
> > default now. The clock is ticking for an ever-growing stream of people
> > upset that they can't mount/data-rescue/etc their rPi5 NAS disks from an
> > x86 machine ;)
> 
> As long as they are using 5.15+ kernel, they should be able to mount and 
> use their RPI NAS with disks from x86 machines.

Doesn't the subpage sectorsize featureset only support sectors less than page
size, not the other way round?

"mkfs.btrfs -s 16K" fails to mount on 6.1.62:

[1077897.120376] BTRFS error (device dm-22): sectorsize 16384 not yet supported for page size 4096
[1077897.120624] BTRFS error (device dm-22): superblock contains fatal errors
[1077897.121394] BTRFS error (device dm-22): open_ctree failed

-- 
With respect,
Roman
