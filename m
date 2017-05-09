Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:50066 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751210AbdEITez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 15:34:55 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH ping] btrfs: warn about RAID5/6 being experimental at
 mount time
References: <20170419210745.15263-1-kilobyte@angband.pl>
 <20170426021416.us4zj2blho26sjgc@angband.pl>
 <20170505194530.GP10575@twin.jikos.cz>
 <20170509014912.kjc6tjwuw4l4kvyh@angband.pl>
To: Adam Borowski <kilobyte@angband.pl>, dsterba@suse.cz,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <384c39b2-d0ec-1bad-9b57-311f50850a6d@inwind.it>
Date: Tue, 9 May 2017 21:34:49 +0200
MIME-Version: 1.0
In-Reply-To: <20170509014912.kjc6tjwuw4l4kvyh@angband.pl>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2017-05-09 03:49, Adam Borowski wrote:
> Write hole is pretty nasty for metadata (likely to cause total filesystem
> loss) but when on -draid{5,6} -mraid{1,10} it's nowhere as bad.  So for 4.12
> it might be ok to put up big warnings only for metadata.  On the other hand,
> data loss limited to 1-2 files is still data loss -- CoW is supposed to
> never damage files already written.
> 
> A real fix is obviously better than slapping on warnings.

The write hole is a real concern ? Only in the last year the linux MD raid implementation has gained a journal to avoid this problem. This means the in the last 15-years (or even more) this problem was here but its severity was "acceptable".

What I am trying to say, is that until the kernel 4.12, btrfs  had several bugs which prevent to work even the basic raid5/6 functionalities (i.e. rebuild). This is a thing that the user should be warned. Because these kinds of bugs are unexpected by a "stable filesystem".

But the raid5/6 write hole is "defect" of all raid5/6 implementation. Until ZFS and the last iteration of MD, the real/only mitigation was a battery backup. In this BTRFS is not worse (nor better) than its competitor (xfs/ext3,4....). I am inclined to think that a warning for the write hole is a bit excessive.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
