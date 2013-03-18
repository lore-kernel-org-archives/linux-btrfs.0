Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:55383 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3CRWnw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 18:43:52 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: linux-btrfs@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
Subject: Re: corruption of active mmapped files in btrfs snapshots
References: <orhak8fm0u.fsf@livre.home>
Date: Mon, 18 Mar 2013 19:43:28 -0300
In-Reply-To: <orhak8fm0u.fsf@livre.home> (Alexandre Oliva's message of "Mon,
	18 Mar 2013 18:14:41 -0300")
Message-ID: <or8v5kfhwv.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While I wrote the previous email, a smoking gun formed in one of my
servers: a snapshot that had passed a database consistency check turned
out to be corrupted when I tried to rollback to it!  Since the snapshot
was not modified in any way between the initial scripted check and the
later manual check, the problem must be in btrfs.

On Mar 18, 2013, Alexandre Oliva <oliva@gnu.org> wrote:

> I've scripted regular checks of osd snapshots, saving the
> last-known-good database along with the first one that displays the
> corruption.  Studying about two dozen failures over the weekend, that
> took place on all of 13 btrfs-based osds on 3 servers running btrfs as
> in 3.8.3(-gnu), I noticed that all of the corrupted databases had a
> similar pattern: a stream of NULs of varying sizes at the end of a page,
> starting at a block boundary (leveldb doesn't do page-sized blocking, so
> blocks can start anywhere in a page), and ending close to the beginning
> of the next page, although not exactly at the page boundary; 20 bytes
> past the page boundary seemed to be the most common size, but the
> occasional presence of NULs in the database contents makes it harder to
> tell for sure.

Additional corrupted snapshots collected today have confirmed this
pattern, except that today I got several corrupted files with non-NULs
right at the beginning of the page following the one that marked the
beginning of the corrupted database block.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
