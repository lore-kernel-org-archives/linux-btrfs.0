From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Chunk map/control
Date: Wed, 10 Nov 2010 10:08:36 -0500
Message-ID: <4CDAB574.2040407@cfl.rr.com>
References: <4C9A631D.2030202@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C9A631D.2030202@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 9/22/2010 4:12 PM, Phillip Susi wrote:
> Is there currently a way to view and manipulate the chunks?  If I
> understand things correctly, a new fs has a few chunks:
> 
> 1)  System chunk.  Contains tree of trees, device tree, chunk tree.
> 2)  Metadata chunk.  Contains the directory tree for the default subvol,
> and any additional subvols/snapshots you create.  Directory entries and
> inodes are in this tree.
> 3)  Data chunk.  Files with significant data have blocks allocated from
> this chunk.
> 
> The system chunk is always mirrored, even on a single disk.  The
> metadata chunk is mirrored by default, but can be changed with a
> parameter to mkfs.  The data chunk is striped by default, but can be
> changed via parameter to mkfs.  The chunks are all expanded as needed.
> Is this correct, and is there a way to create a subvol with a new pair
> of metadata/data chunks and specify how they should be striped or
> mirrored across what devices?

