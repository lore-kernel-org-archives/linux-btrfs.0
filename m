From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Synching a Backup Server
Date: Thu, 06 Jan 2011 22:43:16 +0100
Message-ID: <4D263774.2020903@libero.it>
References: <201101060935.14059.CACook@quantum-sci.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101060935.14059.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2011 06:35 PM, Carl Cook wrote:
> I want to keep a duplicate copy of the HTPC data, on the backup
> server, and I think a regular full file copy is not optimal and may
> take days to do.  So I'm looking for a way to sync the arrays at some
> interval.  Ideally the sync would scan the HTPC with a CRC check to
> look for differences, copy over the differences, then email me on
> success.
> 
> Is there a BTRFS tool that would do this?

There is the command

	btrfs subvolume find-new

which lists the file which have the data (but not the metadata) changed.
But it is a very low level tool.
I tried to enhance this command ( see a my post titled "[RFC] Improve
btrfs subvolume find-new command"), but I never finished this work.

Regards
G.Baroncelli
