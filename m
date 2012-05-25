Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64999 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2EYQiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 12:38:55 -0400
MIME-Version: 1.0
In-Reply-To: <C15A7948-95DF-4B4E-A560-A10A181DE9BB@dilger.ca>
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
	<20120525154249.GC2082@localhost.localdomain>
	<CAB9VWqDGgWE8S4dS5izkzUGEWkUbFSanWCV5trm7VWB0=r-tXQ@mail.gmail.com>
	<C15A7948-95DF-4B4E-A560-A10A181DE9BB@dilger.ca>
Date: Fri, 25 May 2012 18:38:54 +0200
Message-ID: <CAB9VWqDCM5mwnd0nQV8OEcbEa7mt=ySkqWdhbsGk=VpdmY2pog@mail.gmail.com>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
From: Alexander Block <ablock84@googlemail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Josef Bacik <josef@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2012 at 6:28 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2012-05-25, at 9:59, Alexander Block <ablock84@googlemail.com> wrote:
>
> Are you talking about the atime for the primary copy, or the atime for the snapshots?  IMHO, the atime should not be updated for a snapshot unless it is explicitly mounted r/w, or it isn't really a good snapshot.
>
Snapshots are by default r/w but can be created r/o explicitly. But
that doesn't matter for the normal use case where you snapshot / and
continue working on /. After snapshotting, all metadata is shared
between the two subvolumes, but when a metadata block in one of both
subvolume changes (no matter which one), this one metadata block get's
cowed and unshared and uses up more space.
