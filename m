From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC] [PATCH 2/2] Btrfs: move over to use ->update_time
Date: Thu, 12 Apr 2012 13:32:46 +0200
Message-ID: <20120412113246.GC23876@twin.jikos.cz>
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
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, "J. Bruce Fields" <bfields@fieldses.org>,
	Josef Bacik <josef@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	linux-btrfs@vger.kernel.org, hch@infradead.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALLzPKaiYkp15DnP2m+ZdX+zVpVDWPwU7Ct+MrsetAFYXYR0ig@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 02:09:08PM +0300, Kasatkin, Dmitry wrote:
> Where is it? Can you please point out?

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/16662

the relevant part:

-- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -770,7 +770,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
-
+	sb->s_flags |= MS_I_VERSION;
 	err = open_ctree(sb, fs_devices, (char *)data);
 	if (err) {
 		printk("btrfs: open_ctree failed\n");
