From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Thu, 12 Apr 2012 14:43:43 +0300
Message-ID: <CALLzPKavvF4c5x1RLA7OU0wtj5YiVsSrGkw7SsZJbJ8nRdD-Dw@mail.gmail.com>
References: <1332771031-3337-1-git-send-email-josef@redhat.com>
	<1332771031-3337-2-git-send-email-josef@redhat.com>
	<CALLzPKbs7ALeP9sM2OorMiMFCXGs26oPM9=EjBny0NiQi0orSQ@mail.gmail.com>
	<20120404174300.GB2097@localhost.localdomain>
	<1333561669.12904.0.camel@falcor>
	<CALLzPKYvPqi=9dboZDh4Gm0Poouoa2ZY7K3hbhS9bmkiK6nFAQ@mail.gmail.com>
	<20120404181622.GC2097@localhost.localdomain>
	<20120409151605.GA6482@fieldses.org>
	<20120410074801.GE11041@twin.jikos.cz>
	<CALLzPKaiYkp15DnP2m+ZdX+zVpVDWPwU7Ct+MrsetAFYXYR0ig@mail.gmail.com>
	<20120412113246.GC23876@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Josef Bacik <josef@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120412113246.GC23876@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 2:32 PM, David Sterba <dave@jikos.cz> wrote:
> On Thu, Apr 12, 2012 at 02:09:08PM +0300, Kasatkin, Dmitry wrote:
>> Where is it? Can you please point out?
>
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16662
>
> the relevant part:
>
> -- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -770,7 +770,7 @@ static int btrfs_fill_super(struct super_block *s=
b,
> =C2=A0#ifdef CONFIG_BTRFS_FS_POSIX_ACL
> =C2=A0 =C2=A0 =C2=A0 =C2=A0sb->s_flags |=3D MS_POSIXACL;
> =C2=A0#endif
> -
> + =C2=A0 =C2=A0 =C2=A0 sb->s_flags |=3D MS_I_VERSION;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D open_ctree(sb, fs_devices, (char *=
)data);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk("btrfs:=
 open_ctree failed\n");

=46antastic.. I see...
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
