From: Michael Milligan <milli@acmeps.com>
Subject: Re: Cannot Create Partition
Date: Mon, 24 Jan 2011 04:07:20 -0700
Message-ID: <4D3D5D68.5010205@acmeps.com>
References: <201101231007.55046.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101231007.55046.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote:
> On /dev/sda I have sda1 which is my / bootable filesystem for Debian formatted ext4.  This is 256MB on a 2TB drive.
> 
> I want to set up the rest of the drive as BTRFS for various functions, and I presume that I first have to create a partition using fdisk for this?  Since my first part is ext4?  So I:
> # fdisk /dev/sda
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk doesn't support GPT. Use GNU Parted.

Do exactly as you are instructed here.  Use parted.  fdisk doesn't
support GPT partition tables, only MS-DOS tables.

# parted /dev/sda
GNU Parted 2.3
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) []

Now, type "help" if you are stumped.  Or perhaps "man parted".  Or even
use gparted since that's the graphical version and much easier to drive.

Regards,
Mike

