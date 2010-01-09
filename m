From: Tomasz Torcz <tomek@pipebreaker.pl>
Subject: Re: How to mount a subvolume?
Date: Sat, 9 Jan 2010 16:41:13 +0100
Message-ID: <20100109154112.GA25080@mother.pipebreaker.pl>
References: <20100109150757.1051fd79@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100109150757.1051fd79@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 09, 2010 at 03:07:57PM +0100, Dipl.-Ing. Michael Niederle wrote:
> I read that the current tools cannot display subvolumes, but one should still
> be able to mount them. If I try I get an error message:
> 
> > mount -t btrfs -o subvol=root.2010-01-07 /dev/sda3 /save
> mount: /dev/sda3 is not a valid block device
> 
> root.2010-01-07 is a snapshot of the /root-directory
> taken (successfully) with the following command:
> > btrfsctl -s root.2010-01-07 /root
 
  Snapshots aren't subvolumes. You create mountable subvolumes with
btrfsctl -S

-- 
Tomasz Torcz               RIP is irrevelant. Spoofing is futile.
xmpp: zdzichubg@chrome.pl     Your routes will be aggreggated. -- Alex Yuriev

