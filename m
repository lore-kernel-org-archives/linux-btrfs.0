From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Date: Sun, 11 Apr 2010 09:35:37 -0700 (PDT)
Message-ID: <4bc1fa59.c5c2f10a.776d.ffffcd91@mx.google.com>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<4baeaee5.c5c2f10a.7187.2688@mx.google.com>
	<20100327204233.0d84542a@infradead.org>
	<4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com>
	<87y6hcyu85.fsf@basil.nowhere.org>
	<4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
	<4BC1E4A4.1070103@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, tytso@mit.edu, npiggin@suse.de,
	mingo@elte.hu, Ruald Andreae <ruald.a@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Olly Betts <olly@survex.com>,
	martin f krafft <madduck@madduck.net>
To: Avi Kivity <avi@redhat.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BC1E4A4.1070103@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 11 Apr 2010 18:03:00 +0300, Avi Kivity <avi@redhat.com> wrote:
> On 04/09/2010 05:56 PM, Ben Gamari wrote:
> > On Mon, 29 Mar 2010 00:08:58 +0200, Andi Kleen<andi@firstfloor.org>  wrote:
> >    
> >> Ben Gamari<bgamari.foss@gmail.com>  writes:
> >> ext4/XFS/JFS/btrfs should be better in this regard
> >>
> >>      
> > I am using btrfs, so yes, I was expecting things to be better. Unfortunately,
> > the improvement seems to be non-existent under high IO/fsync load.
> >
> 
> btrfs is known to perform poorly under fsync.
> 
Has the reason for this been identified? Judging from the nature of metadata
loads, it would seem that it should be substantially easier to implement
fsync() efficiently.

- Ben

