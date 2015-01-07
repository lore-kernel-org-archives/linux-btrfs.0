Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50513 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752603AbbAGUKN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Jan 2015 15:10:13 -0500
Message-ID: <54AD929E.608@fb.com>
Date: Wed, 7 Jan 2015 15:10:06 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: price to pay for nocow file bit?
References: <20150107174315.GA21865@gardel-login>
In-Reply-To: <20150107174315.GA21865@gardel-login>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/2015 12:43 PM, Lennart Poettering wrote:
> Heya!
>
> Currently, systemd-journald's disk access patterns (appending to the
> end of files, then updating a few pointers in the front) result in
> awfully fragmented journal files on btrfs, which has a pretty
> negative effect on performance when accessing them.
>

I've been wondering if mount -o autodefrag would deal with this problem 
but I haven't had the chance to look into it.

> Now, to improve things a bit, I yesterday made a change to journald,
> to issue the btrfs defrag ioctl when a journal file is rotated,
> i.e. when we know that no further writes will be ever done on the
> file.
>
> However, I wonder now if I should go one step further even, and use
> the equivalent of "chattr -C" (i.e. nocow) on all journal files. I am
> wondering what price I would precisely have to pay for
> that. Judging by this earlier thread:
>
>          https://urldefense.proofpoint.com/v1/url?u=http://www.spinics.net/lists/linux-btrfs/msg33134.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=ODekp6cRJncqEDXqNoiRQ1kLtNawlAzzBmNPpCF7hIw%3D%0A&s=3868518396650e6542b0189719e11f9c490e400c5205c29a20db0b699969c414
>
> it's mostly about data integrity, which is something I can live with,
> given the conservative write patterns of journald, and the fact that
> we do our own checksumming and careful data validation. I mean, if
> btrfs in this mode provides no worse data integrity semantics than
> ext4 I am fully fine with losing this feature for these files.
>

Yup its no worse than ext4.

> Hence I am mostly interested in what else is lost if this flag is
> turned on by default for all journal files journald creates:
>
> Does this have any effect on functionality? As I understood snapshots
> still work fine for files marked like that, and so do
> reflinks. Any drawback functionality-wise? Apparently file compression
> support is lost if the bit is set? (which I can live with too, journal
> files are internally compressed anyway)
>

Yeah no compression, no checksums.  If you do reflink then you'll COW 
once and then the new COW will be nocow so it'll be fine.  Same goes for 
snapshots.  So you'll likely incur some fragmentation but less than 
before, but I'd measure to just make sure if it's that big of a deal.

> What about performance? Do any operations get substantially slower by
> setting this bit? For example, what happens if I take a snapshot of
> files with this bit set and then modify the file, does this result in
> a full (and hence slow) copy of the file on that occasion?
>

Performance is the same.

> I am trying to understand the pros and cons of turning this bit on,
> before I can make this change. So far I see one big pro, but I wonder
> if there's any major con I should think about?
>

Nope there's no real con other than you don't get csums, but that 
doesn't really matter for you.  Thanks,

Josef
