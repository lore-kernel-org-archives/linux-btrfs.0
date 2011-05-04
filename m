From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs csum failed
Date: Wed, 04 May 2011 16:09:16 +0200
Message-ID: <4DC15E0C.8080508@jan-o-sch.net>
References: <4DC07A10.7070200@mur.at>	<20110504002815.GA27861@dhcp231-156.rdu.redhat.com>	<4DC0A153.3080806@mur.at>	<BANLkTin1quUuSq4oKdt1SowTPv4dhGEM5g@mail.gmail.com>	<4DC13B02.9030604@mur.at> <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTiniD_mztDPriodDWybTzt7Dqtherg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04.05.2011 13:51, cwillu wrote:
> On Wed, May 4, 2011 at 5:39 AM, Martin Schitter <ms@mur.at> wrote:
>> and the 'nodatasum' option should also ignore csum issues.-- isn't it?
> 
> No, it only affects writing new checksums; any existing checksums are
> still checked.

>From the report I assume this must be the case for meta data, but it
does not stand true for data. I was just looking at
btrfs_readpage_end_io_hook for some other reason and realized it skips
checksum checking when the file system is mounted nodatasum.

-Jan
