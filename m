From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Synching a Backup Server
Date: Fri, 7 Jan 2011 03:12:13 +0700
Message-ID: <AANLkTi=0vbAwvcde+7whp-3wYt7p_vmbsdZm27LcyT80@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101060935.14059.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 12:35 AM, Carl Cook <CACook@quantum-sci.com> wrote:
> I want to keep a duplicate copy of the HTPC data, on the backup server

> Is there a BTRFS tool that would do this?

AFAIK zfs is the only opensource filesystem today that can transfer
block-level delta between two snapshots, making it ideal for backup
purposes.

With other filesystems, something like rsync + LVM snapshot  is
probably your best bet, and it doesn't really care what filesystem you
use.
