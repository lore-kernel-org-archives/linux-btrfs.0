From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Thu, 19 Jan 2012 11:52:02 -0500
Message-ID: <CALJXSJo6+=c=iNUi4g1NqVbmWWL6ggBsqVad2qC2Hct5jv7i2w@mail.gmail.com>
References: <cover.1301542804.git.larry@elder-gods.org>
	<20110401133405.GA17956@infradead.org>
	<1301665083-sup-3969@think>
	<201112222324.16871.chris@csamuel.org>
	<4F06E33C.8090104@gmail.com>
	<20120106175713.GS7322@twin.jikos.cz>
	<CAAdM645a0vyaXxoqxTpohNZCJ-=+i380m90wEkcixR62xgiBjQ@mail.gmail.com>
	<CALJXSJqgm=1bmrgWVjnbOoWQs3zKu5Wo2quQqM0UwC3ExX9q8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dave@jikos.cz, Konstantinos Skarlatos <k.skarlatos@gmail.com>,
	Chris Samuel <chris@csamuel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Marios Titas <redneb8888@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJqgm=1bmrgWVjnbOoWQs3zKu5Wo2quQqM0UwC3ExX9q8g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Is there any reason why this can't be applied in for-linus? Does it
need more testing? Still no corruption here after copying the whole
root FS in subvolume after btrfs-convert, this FS is used everyday
with big image files, clients backups of Windows directories (small
files) and 3 snapshots a day, using cp --reflink for whole image copy
to test recovery and more.

BTRFS is the only module I need to recompile on this machine after
each upgrading the kernel to apply this patch.

On Mon, Jan 9, 2012 at 8:31 AM, J=C3=A9r=C3=B4me Poulin <jeromepoulin@g=
mail.com> wrote:
> On Mon, Jan 9, 2012 at 1:58 AM, Marios Titas <redneb8888@gmail.com> w=
rote:
>>> The simple case of 'cp --reflink' works fine [...]
>>
>> It doesn't work here:
>>
>> cp: failed to clone `/tmp/test': Invalid cross-device link
>>
>> That's with 3.1 + for-linus.
>
> This is the problem, it doesn't work because you have to apply the
> patch at http://permalink.gmane.org/gmane.comp.file-systems.btrfs/986=
5
> which is not mainlined yet. This patch dates back from March 31st, I
> have been using it since it was released.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
