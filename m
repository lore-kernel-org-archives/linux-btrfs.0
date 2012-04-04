From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Wed, 4 Apr 2012 21:12:57 +0300
Message-ID: <CALLzPKYvPqi=9dboZDh4Gm0Poouoa2ZY7K3hbhS9bmkiK6nFAQ@mail.gmail.com>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
	<1332771031-3337-2-git-send-email-josef@redhat.com>
	<CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
	<20120404174300.GB2097@localhost.localdomain>
	<1333561669.12904.0.camel@falcor>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org,
	hch@infradead.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1333561669.12904.0.camel@falcor>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 4, 2012 at 8:47 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> w=
rote:
> On Wed, 2012-04-04 at 13:43 -0400, Josef Bacik wrote:
>> On Wed, Apr 04, 2012 at 08:24:19PM +0300, Kasatkin, Dmitry wrote:
>> > Hello,
>> >
>> > Mimi and I working on IMA/EVM (security/integrity) and it uses
>> > i_version for checking if file content has been changed.
>> > extX file systems support i_version updates with mounting file sys=
tem
>> > with "iversion" option or via kernel command line parameter
>> > "i_version"
>> >
>> > It seems iversion option is not recognized when mounting btrfs.
>> > I see this patchset deals with i_version update as well..
>> > Can you please give an advice how to use i_version with btrfs?
>> >
>>
>> Oh good somebody uses this? =C2=A0We actually have a ->sequence thin=
g we use for
>> this, the grand idea was to make it smarter about telling nfs when s=
omething
>> changed, but if you guys use i_version we could probably get rid of =
our in-core
>> sequence and use the normal inodes i_version and then just store it =
in our
>> sequence field on disk. =C2=A0I'll do it without a mount option tho =
so it just works,
>> does that sound good to you? =C2=A0Thanks,

Hello,

Thank you for the answer...
But can you a bit clarify...

Looking to file_update_time() I see that it does:

	if (IS_I_VERSION(inode))
		sync_it |=3D S_VERSION;

Basically it should be (inode->i_sb->s_flags & MS_I_VERSION)

use of i_version is controlled by iversion mount flag.
for ext4 I see in parse_options():

		case Opt_i_version:
			set_opt(sb, I_VERSION);
			sb->s_flags |=3D MS_I_VERSION;
			break;


But who sets MS_I_VERSION in s_flags on btrfs?


Thanks.

- Dmitry

>>
>> Josef
>
> Sounds really good!
>
> thanks,
>
> Mimi
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
