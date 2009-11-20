From: Albert Strasheim <fullung@gmail.com>
Subject: Re: fsck.btrfs assertion failure with large number of disks in fs
Date: Fri, 20 Nov 2009 13:44:51 +0200
Message-ID: <5eec5f300911200344r7bcf391auac31689e1f89e494@mail.gmail.com>
References: <5eec5f300911192231m33ea0ad4ye9a7fd5eec085cc0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5eec5f300911192231m33ea0ad4ye9a7fd5eec085cc0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 20, 2009 at 8:31 AM, Albert Strasheim <fullung@gmail.com> wrote:
> We are experimenting with btrfs and we've run into some problems.
> We are running on two Sun Storage J4400 Arrays containing a total of
> 48 1 TB disks.
> With 24 disks in the btrfs:
> Now with one more disk:

False alarm. Turns out the server was seeing the same JBOD twice,
instead of seeing both JBODs, so trying to use more than 24 disks of
course led to a corrupted file system.

Regards,

Albert
