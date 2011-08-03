From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: [PATCH] btrfs: do not allow mounting non-subvolumes via subvol option
Date: Wed, 3 Aug 2011 14:08:06 -0500
Message-ID: <CAGAVQTGokKiSkcKR0+ibX+ZAdz3tQFfGxEVuAW=bobaAu4d9eA@mail.gmail.com>
References: <1311934448-887-1-git-send-email-dsterba@suse.cz>
 <1865303E0DED764181A9D882DEF65FB6B1A8DFC32F@shsmsx502.ccr.corp.intel.com> <20110803184713.GE28122@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: dave@jikos.cz, "Zhong, Xin" <xin.zhong@intel.com>,
	David Sterba <dsterba@suse.cz>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@o
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110803184713.GE28122@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 3, 2011 at 1:47 PM, David Sterba <dave@jikos.cz> wrote:
> On Sat, Jul 30, 2011 at 12:16:44AM +0800, Zhong, Xin wrote:
>> I believe I have submit a similar patch months ago:
>> http://marc.info/?l=linux-btrfs&m=130208585106572&w=2
>
> You did! I was not aware of that. I believe adding a helper make things
> more clear (if it were used all over the code).
>
>> Hope it can be integrated this time, :-).
>
> mehopes too

i corrupted an FS after doing this back in Nov of last year (though i
was also --bind mounting it after the fact)

http://marc.info/?l=linux-btrfs&m=129091436915724&w=2

...and a patch proposed:

http://marc.info/?l=linux-btrfs&m=129091815217860&w=2

C Anthony
