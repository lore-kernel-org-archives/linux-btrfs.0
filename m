From: Bardur Arantsson <spam@scientician.net>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Wed, 02 May 2012 07:00:00 +0200
Message-ID: <jnqf0j$hcd$1@dough.gmane.org>
References: <jnpdud$ta9$1@dough.gmane.org> <jnq5os$tdn$1@dough.gmane.org> <CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/2012 06:28 AM, Fajar A. Nugraha wrote:
> On Wed, May 2, 2012 at 9:22 AM, Bardur Arantsson<spam@scientician.net>  wrote:
>> On 05/01/2012 09:35 PM, Martin wrote:
>>>
>>
>>  From Kconfig:
>>
>>    "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
>>                       ^^^^^^^^^^^^   ^^^^^^^^^^^^^^^^^^
>>
>> Btrfs is too immature to use in ANY kind of production-like scenario where
>> you cannot afford to lose a certain amount of data (i.e. be forced to
>> restore from backup) AND suffer downtime.
>>
>> I don't think email users are going to be thrilled about the prospect of
>> "lossy" email.
>
> Oracle fully supports btrfs for production environment:
> http://oss.oracle.com/ol6/docs/RELEASE-NOTES-UEK2-en.html
> http://www.zdnet.com/blog/open-source/oracles-unbreakable-enterprise-kernel-2-arrives-with-linux-30-kernel-btrfs/10588
> http://www.oracle.com/us/technologies/linux/index.html
>

What does "fully supports" mean? Does it mean that it's actually stable 
(considerably more stable that mainline), or does it mean that you can 
pay them to help fix a broken FS, for example? Does the included btrfsck 
actually work reliably? Is there some non-legalese official statement of 
what, exactly, "fully supported" means and whether OL's btrfs falls 
under this rubric?

Also, AFAIUI the 3.0.x kernels (which OL claims to use in the release 
notes) are woefully outdated wrt. btrfs reliability/stability. Have all 
the more recent stability improvements been backported?

Is the OP using Oracle Linux?

Given the semi-regular posts about FS corruption on this list(*) and the 
"EXPERIEMENTAL" status in the KConfig it would be unwise to use btrfs 
for anything called "production" (unless you can actually afford 
downtime/data loss).


(*) I want to make clear that the developers on this list always seem 
incredibly responsive and helpful when these posts occur, but it's still 
an indication of not-readiness for "production". File systems always 
take quite a long time to mature, it's just the nature of the beast.

Regards,

