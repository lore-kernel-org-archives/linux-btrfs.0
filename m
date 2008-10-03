From: Zach Brown <zach.brown@oracle.com>
Subject: Re: packing structures and numbers
Date: Fri, 03 Oct 2008 11:37:13 -0700
Message-ID: <48E66659.1030202@oracle.com>
References: <48E6053A.8010100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48E6053A.8010100@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Avi Kivity wrote:
> I've been reading btrfs's on-disk format, and two things caught my eye
> 
> - attribute((packed)) structures everywhere, often with misaligned
> fields.  This conserves space, but can be harmful to in-memory
> performance on some archs.

How harmful?  Do you have any profiles that can even pick this out of
the noise?

- z
