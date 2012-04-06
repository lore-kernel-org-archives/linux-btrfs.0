From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: kernel BUG at extent-tree.c:3162 (get_restripe_target)
Date: Fri, 6 Apr 2012 10:52:13 -0500
Message-ID: <CAKcLGm990SucW0qUHfiG75=jWQid-q8hJ0cCgJLWMATpGWvQnw@mail.gmail.com>
References: <CAKcLGm8SgQchrk1fVg0FZ9uqr1v+cLzoWt1jk7vsJdZVfA72pA@mail.gmail.com>
	<20120406154314.GI14256@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120406154314.GI14256@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 6, 2012 at 10:43 AM, David Sterba <dave@jikos.cz> wrote:
> On Fri, Apr 06, 2012 at 10:33:04AM -0500, Mitch Harder wrote:
>> I'm consistently hitting the BUG_ON in the new get_restripe_target
>> function that was added by "[PATCH 4/8] Btrfs: add
>> get_restripe_target() helper" when trying to initially mount a btrfs
>> partition.
>>
>> Lines fs/btrfs/extent-tree.c:3161-3162:
>>
>> =A0 =A0 =A0 BUG_ON(!mutex_is_locked(&fs_info->volume_mutex) &&
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0!spin_is_locked(&fs_info->balance_lock));
>
> Is it a single CPU machine? See
>
> http://www.spinics.net/lists/linux-btrfs/msg15884.html
>

Thanks!

Yes, this is a single CPU machine.  I'll test the solution from that th=
read.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
