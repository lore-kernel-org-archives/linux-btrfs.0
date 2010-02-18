From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 22:25:09 +0100
Message-ID: <20100218212509.GD24141@mother.pipebreaker.pl>
References: <201002172102.17816.kreijack@libero.it>
 <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
 <20100218165841.GO10559@think>
 <201002182100.00624.kreijack@libero.it>
 <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 12:46:56PM -0800, Mike Fedyk wrote:
> btrfs defrag file <file>
> btrfs defrag directory <directory>
> btrfs defrag subvol <subvol>
> btrfs defrag pool <pool>

  I think this could be implied by <target>, so it will be better to drop
3rd word:

btrfs defrag /this/file
btrfs defrag /mnt/btrfs/somedir/
btrfs defrag /dev/sda2  		# for pool
btrfs defrag LABEL="lnx-test"		# for pool; libblkid integration is nice :)

-- 
Tomasz Torcz                 "God, root, what's the difference?"
xmpp: zdzichubg@chrome.pl         "God is more forgiving."

