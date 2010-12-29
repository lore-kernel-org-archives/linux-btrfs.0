From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Subject: Re: [PATCH] x86: hpet: Fix HPET timer + NMI watchdog panic
Date: Wed, 29 Dec 2010 10:43:12 +0800
Message-ID: <AANLkTim5GRu7rW2ws8ASTNyxmRYk3nO6g+dKLvxkgfEb@mail.gmail.com>
References: <4D1A9571.4030604@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mingo@redhat.com, tglx@linutronix.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D1A9571.4030604@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sent this mail to wrong list, sorry for interrupting.

Yan, Zheng

On Wed, Dec 29, 2010 at 9:57 AM, Yan, Zheng <zheng.z.yan@linux.intel.co=
m> wrote:
> HPET doesn't use timer_interrupt() as interrupt handler now. So count=
 of
> HPET interrupt isn't recorded in per_cpu(irq_stat, cpu).irq0_irqs. Th=
is
> confuses NMI watchdog when using HPET as tick device.
>
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
>
> ---
> diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/ha=
rdirq.h
> index 55e4de6..cca94f2 100644
> --- a/arch/x86/include/asm/hardirq.h
> +++ b/arch/x86/include/asm/hardirq.h
> @@ -12,6 +12,9 @@ typedef struct {
> =A0 =A0 =A0 =A0unsigned int apic_timer_irqs; =A0 /* arch dependent */
> =A0 =A0 =A0 =A0unsigned int irq_spurious_count;
> =A0#endif
> +#ifdef CONFIG_HPET_TIMER
> + =A0 =A0 =A0 unsigned int hpet_timer_irqs;
> +#endif
> =A0 =A0 =A0 =A0unsigned int x86_platform_ipis; /* arch dependent */
> =A0 =A0 =A0 =A0unsigned int apic_perf_irqs;
> =A0 =A0 =A0 =A0unsigned int apic_irq_work_irqs;
> diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
> index c90041c..cdb38d9 100644
> --- a/arch/x86/kernel/apic/nmi.c
> +++ b/arch/x86/kernel/apic/nmi.c
> @@ -80,8 +80,15 @@ static inline int mce_in_progress(void)
> =A0*/
> =A0static inline unsigned int get_timer_irqs(int cpu)
> =A0{
> - =A0 =A0 =A0 return per_cpu(irq_stat, cpu).apic_timer_irqs +
> + =A0 =A0 =A0 unsigned int irqs;
> +#ifdef CONFIG_HPET_TIMER
> + =A0 =A0 =A0 irqs =3D per_cpu(irq_stat, cpu).hpet_timer_irqs;
> +#else
> + =A0 =A0 =A0 irqs =3D 0;
> +#endif
> + =A0 =A0 =A0 irqs +=3D per_cpu(irq_stat, cpu).apic_timer_irqs +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0per_cpu(irq_stat, cpu).irq0_irqs;
> + =A0 =A0 =A0 return irqs;
> =A0}
>
> =A0#ifdef CONFIG_SMP
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 4ff5968..b536474c 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -517,6 +517,7 @@ static irqreturn_t hpet_interrupt_handler(int irq=
, void *data)
> =A0 =A0 =A0 =A0struct hpet_dev *dev =3D (struct hpet_dev *)data;
> =A0 =A0 =A0 =A0struct clock_event_device *hevt =3D &dev->evt;
>
> + =A0 =A0 =A0 inc_irq_stat(hpet_timer_irqs);
> =A0 =A0 =A0 =A0if (!hevt->event_handler) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_INFO "Spurious HPET timer =
interrupt on HPET timer %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev->n=
um);
> diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
> index fb5cc5e1..2098c56 100644
> --- a/arch/x86/kernel/time.c
> +++ b/arch/x86/kernel/time.c
> @@ -56,7 +56,7 @@ unsigned long profile_pc(struct pt_regs *regs)
> =A0EXPORT_SYMBOL(profile_pc);
>
> =A0/*
> - * Default timer interrupt handler for PIT/HPET
> + * Default timer interrupt handler for PIT
> =A0*/
> =A0static irqreturn_t timer_interrupt(int irq, void *dev_id)
> =A0{
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
