From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: add support for mixed data+metadata block groups V3
Date: Wed, 20 Oct 2010 23:21:26 -0500
Message-ID: <AANLkTi=9uDOLNk3JnLN=okVWwSZBvfpSdMwvAWkMJK0g@mail.gmail.com>
References: <1286452263-1635-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1286452263-1635-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I've been testing this patch (as well as the accompanying patch to btrfs-progs).

It seems to save a decent amount of space (maybe 10-20% according to
df in my testing, YMMV), but I was also noticing a performance penalty
of maybe 5-15%, depending on the application (in my case, I was timing
the untar-ing of data to a btrfs partition).

I also developed the perception that I was encountering some minor
latency issues when heavily using a drive formated for mixed data and
metadata (more keyboard and mouse hesitations than normal, difficult
stuff to quantify).

The main problem I encountered was a btrfs crash when booting with an
un-patched kernel, and letting the boot process attempt to mount the
drive with mixed data+metadata.  I wasn't entirely surprised by this
result, but it was unclear from the patch description whether a volume
formatted with mixed data+metadata would be incompatible with an
un-patched, older kernel.

Other than that, it seemed to perform well.  I did not encounter any
stability issues as long as I was using a patched kernel.
